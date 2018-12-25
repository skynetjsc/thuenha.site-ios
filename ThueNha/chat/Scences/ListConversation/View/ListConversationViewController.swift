//
//  ListConversationViewController.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

protocol ListConversationViewControllerInput: ListConversationPresenterOutput {

}

protocol ListConversationViewControllerOutput {

    func requestListConversation(request: ListConversation.Request)
    func requestDeleteConversation(request: ListConversation.Request.DeleteConversation)
    func requestConfirmRent(request: ListConversation.Request.ConfirnRent)
}

final class ListConversationViewController: BaseViewController {

    var output: ListConversationViewControllerOutput!
    var router: ListConversationRouterProtocol!
    
    @IBOutlet weak var tableView: UITableView?
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var displayedTable = ListConversation.ViewModel.DisplayedTable()

    // MARK: - Initializers

    init(configurator: ListConversationConfigurator = ListConversationConfigurator()) {
        super.init(nibName: nil, bundle: nil)
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: ListConversationConfigurator = ListConversationConfigurator()) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.navigationItem.title = "Hội thoại"

        configureTableView()
        
        onRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedRow = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Memory managerment
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    deinit {
        print("ListConversationViewController \(#function)")
    }
    
    // Configure
    
    private func configureTableView() {
        tableView?.register(nib: ListConversationCell.nib, withCellClass: ListConversationCell.self)
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 100
        tableView?.separatorStyle = .none
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView?.addSubview(refreshControl)
    }
}

// MARK: - Load data

extension ListConversationViewController {
    
    @objc func onRefresh() {
        refreshControl.beginRefreshing()
        
        let type : Int = UserManager.user.type();
        let userid : String = UserManager.user.id();
        let request = ListConversation.Request(idUser: Int(userid)!, type: type)
        
        output.requestListConversation(request: request)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ListConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let displayedSection = displayedTable.sections
        return displayedSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let displayedSection = displayedTable.sections[section]
        return displayedSection.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayedSection = displayedTable.sections[indexPath.section]
        let displayedCell = displayedSection.cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withClass: ListConversationCell.self, for: indexPath)
        if let conversation = displayedCell.conversation {
            cell.lblTimeLastMessage?.text = conversation.timeUpdated
            cell.lblLastMessage?.text = conversation.lastMessage
            if (UserManager.user.type() == 1) {
                cell.lblName?.text = conversation.host?.name?.length == 0 ? " " : conversation.host?.name
                if let avatarURL = URL(string: conversation.host?.avatar ?? "") {
                    cell.avatar?.kf.setImage(with: avatarURL)
                }
            } else if (UserManager.user.type() == 2) {
                cell.lblName?.text = conversation.user?.name?.length == 0 ? " " : conversation.user?.name
                if let avatarURL = URL(string: conversation.user?.avatar ?? "") {
                    cell.avatar?.kf.setImage(with: avatarURL)
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.navigateToConversation()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let displayedSection = displayedTable.sections[indexPath.section]
        let displayedCell = displayedSection.cells[indexPath.row]
        
        guard let conversation = displayedCell.conversation else {
            return
        }
        
        guard let postID = conversation.idPost,
            let userID = conversation.user?.id,
            let hostID = conversation.host?.id else {
                return
        }
        
        switch editingStyle {
        case .delete:
            MBProgressHUD().show(animated: true)
            let request = ListConversation.Request.DeleteConversation(idPost: postID,
                                                                      idUser: userID,
                                                                      idHost: hostID)
            output.requestDeleteConversation(request: request)
            break
        default:
            if (UserManager.user.type() == 1) {
                self.alert("Tài khoản của bạn không thể thực hiện chức năng này. Vui lòng đăng nhập với tư cách người cho thuê!")
            } else {
                router.chuyen_den_man_cho_thue(post_id: postID)
            }
            //let request = ListConversation.Request.ConfirnRent(idPost: postID, idUser: userID,idHost: hostID)
            //output.requestConfirmRent(request: request)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Xoá") { (action, indexPath) in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor.red
        
        //confirm
        let confirmButton = UITableViewRowAction(style: .default, title: "Xác nhận cho thuê") { (action, indexPath) in
            tableView.dataSource?.tableView!(tableView, commit: .none, forRowAt: indexPath)
            return
        }
        confirmButton.backgroundColor = UIColor.orange
        return [deleteButton, confirmButton]
    }
}

// MARK: - ListConversationPresenterOutput

extension ListConversationViewController: ListConversationViewControllerInput {
    
    // MARK: - Display logic
    
    func displayListConversation(viewModel: ListConversation.ViewModel) {
        if let displayedTable = viewModel.displayedTable {
            self.displayedTable = displayedTable
        }
        self.tableView?.reloadData { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func displayDeleteConversation() {
        MBProgressHUD().hide(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onRefresh()
        }
    }
    
    func displayConfirmRent() {
        MBProgressHUD().hide(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onRefresh()
        }
    }
}
