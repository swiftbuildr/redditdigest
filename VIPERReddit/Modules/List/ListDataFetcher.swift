//
// Created by Samuel Ward on 19/01/2018.
// Copyright (c) 2018 Swiftbuildr Ltd. All rights reserved.
//

import Foundation

protocol ListInteractorInput {
    func getList()
}

protocol ListInteractorOutput: class {
    func didGetList(result: Result<ListEntity>)
}

class ListInteractor: DataFetcher, ListInteractorInput {

    private let api: ListAPI
    weak var output: ListInteractorOutput?

    init(api: ListAPI) {

        self.api = api
    }

    func getList() {

        fetch(with: ()) { result in self.output?.didGetList(result: result) }
    }

    func fetch(with context: Void, completion: @escaping (Result<ListEntity>) -> Void) {

        _ = api.get() {
            result in

            DispatchQueue.main.async {

                switch result {
                    case .success(let data):

                        let children = data.data.children

                        let formatter = DateFormatter()
                        formatter.dateStyle = .long

                        let listItems: [ListEntity.ListItem] = children.map {
                            ListEntity.ListItem(id: $0.data.id, title: $0.data.title,
                                                descriptionText: $0.data.author)
                        }

                        let entity = ListEntity(listItems: listItems)
                        completion(.success(entity))
                    case .failure(_):
                        completion(.failure(NSError()))
                }
            }
        }
    }
}
