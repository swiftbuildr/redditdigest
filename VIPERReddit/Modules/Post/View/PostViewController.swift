//
// Created by Samuel Ward on 19/01/2018.
// Copyright (c) 2018 Swiftbuildr Ltd. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController, PostView {

    var presenter: PostPresenterInput?
    
    var state: ViewState<PostViewModel> = .empty {
        didSet {
            DispatchQueue.main.async {
                switch self.state {
                case .loaded(let viewModel):
                    self.tableView.refreshControl?.endRefreshing()
                    self.title = viewModel.title
                    self.tableView.reloadData()
                    break
                case .error:
                    self.tableView.refreshControl?.endRefreshing()
                    break
                case .loading:
                    self.tableView.refreshControl?.beginRefreshing()
                    break
                case .empty:
                    break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
    
        return state.loadedViewModel?.rows.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let viewModel = state.loadedViewModel else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.rows[indexPath.row].reuseIdentifier,
                                                 for: indexPath)
        
        switch cell {
            case let cell as ImageTableViewCell:
                cell.viewModel = viewModel.rows[indexPath.row] as? PostViewModel.ImageRow
            case let cell as TitleTableViewCell:
                cell.viewModel = viewModel.rows[indexPath.row] as? PostViewModel.TitleRow
            case let cell as AuthorTableViewCell:
                cell.viewModel = viewModel.rows[indexPath.row] as? PostViewModel.AuthorRow
            default:
                break
        }
        
        return cell
    }
}
