//
//  ChatGroupDetailsViewController.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class ChatGroupDetailsViewController: UIViewController, BindableType {
    var viewModel: ChatGroupDetailsViewModel!
    
    // MARK: - IBOutlets
    @IBOutlet weak var chatGroupDetailsTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var chatBoxTextView: UITextView!
    @IBOutlet weak var chatBoxHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - RxSwift Props
    var disposeBag = DisposeBag.init()
        
    // MARK: - RxSwift Data Source
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<MessageSectionModel>(configureCell: configureCell)
    private lazy var configureCell: RxTableViewSectionedAnimatedDataSource<MessageSectionModel>.ConfigureCell = { [weak self] (dataSource, tableView, indexPath, item) in
        guard let strongSelf = self else { return UITableViewCell() }
        if item.isloggedInUserMessage == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatFragmentRightTableViewCell.identifier, for: indexPath) as! ChatFragmentRightTableViewCell
            cell.chatLabel.text = item.identity.message ?? ""
            cell.otherDetailsLabel.text = "Me @ \(Double(item.identity.timestamp ?? 0).toDate())"
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatFragmentLeftTableViewCell.identifier, for: indexPath) as! ChatFragmentLeftTableViewCell
            cell.chatLabel.text = item.identity.message ?? ""
            cell.otherDetailsLabel.text = "\(item.identity.name ?? "") @ \(Double(item.identity.timestamp ?? 0).toDate())"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // MARK: - Lifecycle method @ viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewNibsAndDelegate()
        self.setNavigationTitle(to: viewModel.groupName)
    }
    
    func registerTableViewNibsAndDelegate() {
        self.chatGroupDetailsTableView.separatorColor = .clear
        self.chatGroupDetailsTableView.register(UINib.init(nibName: ChatFragmentLeftTableViewCell.className, bundle: nil), forCellReuseIdentifier: ChatFragmentLeftTableViewCell.identifier)
        self.chatGroupDetailsTableView.register(UINib.init(nibName: ChatFragmentRightTableViewCell.className, bundle: nil), forCellReuseIdentifier: ChatFragmentRightTableViewCell.identifier)
    }
    
    // MARK: - ViewModel Data Binding happens here.
    func bindViewModel() {
        let chatBoxValidation = chatBoxTextView.rx.text.map({ !($0!.isEmpty) }).share()
        chatBoxValidation.bind(to: sendButton.rx.isEnabled).disposed(by: disposeBag)
        
        sendButton.rx.tap.bind { (event) in
            self.viewModel.createConversation(for: self.chatBoxTextView.text)
            self.chatBoxTextView.text = ""
            UIView.animate(withDuration: 0.5) {
                self.chatBoxHeightConstraint.constant = 45
                self.view.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        chatBoxTextView.rx.didChange.bind { (event) in
            let size = CGSize.init(width: UIScreen.main.bounds.width - 85 , height: .infinity)
            let estimatedSize = self.chatBoxTextView.sizeThatFits(size)
            
            UIView.animate(withDuration: 0.5) {
                self.chatBoxHeightConstraint.constant = estimatedSize.height
                self.view.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        viewModel.fetchGroupChats()
        viewModel.data
            .asDriver()
            .drive(chatGroupDetailsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.data.bind { (sectionModel) in
            if sectionModel.count == 1 {
                if sectionModel[0].items.count != 0 {
                    DispatchQueue.main.async {
                        self.chatGroupDetailsTableView.scrollToRow(at: IndexPath.init(row: sectionModel[0].items.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
}

