import Hooks
import SwiftUI

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
}

func useFetchPosts() -> (status: AsyncStatus<[Post], Error>, fetch: () -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts").unsafelyUnwrapped
    let (status, subscribe) = usePublisherSubscribe {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
    }

    return (status: status, fetch: subscribe)
}

struct APIRequestPage: HookView {
    var hookBody: some View {
        let (status, fetch) = useFetchPosts()

        return ScrollView {
            VStack {
                switch status {
                case .running:
                    ProgressView()

                case .success(let posts):
                    postRows(posts)

                case .failure(let error):
                    errorRow(error, retry: fetch)

                case .pending:
                    EmptyView()
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
        .navigationTitle("API Request")
        .background(Color(.systemBackground).ignoresSafeArea())
        .onAppear(perform: fetch)
    }

    func postRows(_ posts: [Post]) -> some View {
        ForEach(posts, id: \.id) { post in
            VStack(alignment: .leading) {
                Text(post.title).bold()
                Text(post.body).padding(.vertical, 16)
                Divider()
            }
            .frame(maxWidth: .infinity)
        }
    }

    func errorRow(_ error: Error, retry: @escaping () -> Void) -> some View {
        VStack {
            Text("Error: \(error.localizedDescription)").fixedSize(horizontal: false, vertical: true)
            Divider()
            Button("Refresh", action: retry)
        }
    }
}
