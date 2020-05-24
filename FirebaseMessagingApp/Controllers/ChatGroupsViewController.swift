//
//  ChatGroupsViewController.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ChatGroupsViewController: UIViewController, BindableType {
    var viewModel: ChatGroupsViewModel!
    
    // MARK: - IBOutlets
    @IBOutlet weak var chatGroupsTableView: UITableView!
    @IBOutlet weak var chatFragmentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - RxSwift Props
    var disposeBag = DisposeBag.init()
    var logoutButton = UIBarButtonItem.init(image: UIImage.init(named: "logout"), style: .plain, target: nil, action: nil)
    
    // MARK: - RxSwift Data Source
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<ChatGroupSectionModel>(configureCell: configureCell)
    private lazy var configureCell: RxTableViewSectionedAnimatedDataSource<ChatGroupSectionModel>.ConfigureCell = { [weak self] (dataSource, tableView, indexPath, item) in
        guard let strongSelf = self else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatGroupTableViewCell.identifier, for: indexPath) as! ChatGroupTableViewCell
        cell.groupNameLabel.text = item.identity.name ?? ""
        if let imageLink = item.identity.imageLink {
            cell.groupImageView.setImage(for: imageLink)
        }
        cell.memberLabel.text = item.identity.members.count.description + (item.identity.members.count > 1 ? " Members" : " Member")
        cell.authorLabel.text = item.identity.authorName ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Lifecycle method @ viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationTitle(to: "Chat Groups")
        self.registerTableViewNibsAndDelegate()
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    func registerTableViewNibsAndDelegate() {
        self.chatGroupsTableView.separatorColor = .clear
        self.chatGroupsTableView.register(UINib.init(nibName: ChatGroupTableViewCell.className, bundle: nil), forCellReuseIdentifier: ChatGroupTableViewCell.identifier)
        self.chatGroupsTableView.rx.itemSelected.bind { (indexPath) in
            // Move to particular chat group.
            let sceneCoordinator = (UIApplication.shared.delegate as! AppDelegate).sceneCoordinator
            let chatDetailsViewModel = ChatGroupDetailsViewModel.init()
            chatDetailsViewModel.ref = self.viewModel.ref
            chatDetailsViewModel.groupName = self.dataSource[indexPath.section].items[indexPath.row].chatGroupId
            let chatDetailsScene = Scene.chatGroupDetails(chatDetailsViewModel)
            sceneCoordinator?.transition(to: chatDetailsScene, type: .push)
        }.disposed(by: disposeBag)
    }
    
    
    // MARK: - ViewModel Data Binding happens here.
    func bindViewModel() {
        logoutButton.rx.tap.bind { (event) in
            _ = UserDetails.delteUserDetailsAndLogOut()
            (UIApplication.shared.delegate as! AppDelegate).setLoginAsRootView()
        }.disposed(by: disposeBag)
        viewModel.fetchChatGroups()
        viewModel.data
            .asDriver()
            .drive(chatGroupsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
