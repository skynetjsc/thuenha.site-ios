//
//  ConversationViewController.swift
//  ThueNha
//
//  Created by LTD on 12/6/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

protocol ConversationViewControllerInput: ConversationPresenterOutput {

}

protocol ConversationViewControllerOutput {

    func requestPOSTMessage(request: Conversation.Request.POSTMessage, completion: @escaping() -> Void)
    func requestMessageHistory(request: Conversation.Request)
    func requestSendTnChat(request: Conversation.Request)
}

final class ConversationViewController: BaseChatViewController {

    var output: ConversationViewControllerOutput!
    var router: ConversationRouterProtocol!
    
    var viewModel = Conversation.ViewModel()
    
    var inputBarView: ConversationInputBarView!
    var messageSender: ConversationMessageSender!
    let messagesSelector = ConversationBaseMessagesSelector()
    var dataSource: ConversationDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }
    lazy private var baseMessageHandler: ConversationBaseMessageHandler = {
        return ConversationBaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()

    // MARK: - Initializers

    init(configurator: ConversationConfigurator = ConversationConfigurator()) {
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

    private func configure(configurator: ConversationConfigurator = ConversationConfigurator()) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Title
        if (UserManager.user.type() == 1) {
            self.title = router.dataStore?.conversation?.host?.name
        } else if (UserManager.user.type() == 2) {
            self.title = router.dataStore?.conversation?.user?.name
        }
        
        // Back bar button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        button.setImage(UIImage(named: "backDark"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(touchupInsideBack(_:)), for: .touchUpInside)
        let leftButton: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = ConversationItemsDecorator(messagesSelector: self.messagesSelector)

        // Message History
        output.requestMessageHistory(request: Conversation.Request())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        print("ConversationViewController \(#function)")
    }
    
    // MARK: - Override
    
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        // Text message
        let textMessageViewModelBuilder = ConversationTextMessageViewModelBuilder()
        textMessageViewModelBuilder.user = router.dataStore?.conversation?.user
        textMessageViewModelBuilder.host = router.dataStore?.conversation?.host
        let textMessageInteractionHandler = ConversationTextMessageHandler(baseHandler: self.baseMessageHandler)
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: textMessageViewModelBuilder,
            interactionHandler: textMessageInteractionHandler)
        
        // Bubble background
        let bubbleBackgroundColor = BaseMessageCollectionViewCellDefaultStyle.Colors(
            incoming: UIColor.thueNhaOrange,
            outgoing: UIColor.thueNhaWhite)
        let baseMessageStyle = ConversationBaseMessageCollectionViewCellAvatarStyle(colors: bubbleBackgroundColor)
        
        let textStyle = TextMessageCollectionViewCellDefaultStyle.TextStyle(
            font: UIFont.thueNhaOpenSansRegular(size: 14),
            incomingColor: UIColor.thueNhaWhite,
            outgoingColor: UIColor.thueNhaBlack,
            incomingInsets: UIEdgeInsets(top: 10, left: 19, bottom: 10, right: 15),
            outgoingInsets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 19)
        )
        
        let textCellStyle: TextMessageCollectionViewCellDefaultStyle = TextMessageCollectionViewCellDefaultStyle(
            textStyle: textStyle,
            baseStyle: baseMessageStyle)
        
        textMessagePresenter.baseMessageStyle = baseMessageStyle
        textMessagePresenter.textCellStyle = textCellStyle
        
        // Sending status
        let sendingStatusPresenter = ConversationSendingStatusPresenterBuilder()
        
        // Time separator
        let timeSeparatorPresenter = ConversationTimeSeparatorPresenterBuilder()
        
        // Photo message
        let photoMessagePresenter = ConversationPhotoMessagePresenterBuilder()
        photoMessagePresenter.viewController = self
        
        return [
            ConversationTextMessageModel.chatItemType: [textMessagePresenter],
            ConversationSendingStatusModel.chatItemType: [sendingStatusPresenter],
            ConversationTimeSeparatorModel.chatItemType: [timeSeparatorPresenter],
            ConversationPhotoMessageModel.chatItemType: [photoMessagePresenter]
        ]
    }
    
    override func createChatInputView() -> UIView {
        let chatInputView = ConversationInputBarView.loadNib()
        chatInputView.maxCharactersCount = 255
        chatInputView.inputTextView?.placeholderText = "Nhập nội dung"
        chatInputView.inputTextView?.setTextPlaceholderColor(UIColor.white)
        chatInputView.inputTextView?.setTextPlaceholderFont(UIFont.systemFont(ofSize: 16))
        chatInputView.inputTextView?.textColor = UIColor.white
        chatInputView.inputTextView?.font = UIFont.systemFont(ofSize: 16)
        chatInputView.delegate = self
        self.inputBarView = chatInputView
        return chatInputView
    }
    
}

extension ConversationViewController {
    
    @objc func touchupInsideBack(_ sender: UIButton) {
        router.popViewController(true)
    }
    
    @objc func touchupInsideAddMessage(_ sender: UIButton) {
        self.dataSource.addRandomIncomingTextMessage()
    }
    
}

extension ConversationViewController: ConversationInputBarViewDelegate {
    
    func inputBarSendButtonPressed(_ inputBar: ConversationInputBarView) {
        let request = Conversation.Request(message: inputBar.inputText)
        output.requestSendTnChat(request: request)
    }
}

extension ConversationViewController: ConversationMessagesSelectorDelegate {
    
    func messagesSelector(_ messagesSelector: ConversationMessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
    
    func messagesSelector(_ messagesSelector: ConversationMessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}

// MARK: - ConversationPresenterOutput

extension ConversationViewController: ConversationViewControllerInput {

    // MARK: - Display logic
    
    func displayMessageHistory(viewModel: Conversation.ViewModel) {
        self.viewModel.messagesHistory = viewModel.messagesHistory
        self.viewModel.title = viewModel.title
        
        // Show host name as Title
        self.title = self.viewModel.title
        
        // Show message history
        var messages: [ChatItemProtocol] = []
        
        // Photo
        if let postModel = viewModel.postDetails {
            var isIncoming = false
            if (UserManager.user.type() == 1) {
                isIncoming = false
            } else if (UserManager.user.type() == 2) {
                isIncoming = true
            }
            let photoMessage = ConversationMessageFactory.makePhotoMessage(UUID().uuidString, postModel: postModel, isIncoming: isIncoming)
            messages.append(photoMessage)
        }

        // Text message
        for message in self.viewModel.messagesHistory ?? [] {
            var isIncoming = false
            if let type = message.type {
                switch type {
                case 1:
                    if (UserManager.user.type() == 1) {
                        isIncoming = false
                    } else if (UserManager.user.type() == 2) {
                        isIncoming = true
                    }
                    break
                case 2:
                    if (UserManager.user.type() == 1) {
                        isIncoming = true
                    } else if (UserManager.user.type() == 2) {
                        isIncoming = false
                    }
                    break
                default:
                    break
                }
            }
            let messageModel = ConversationMessageFactory.makeTNChatMessageModel(UUID().uuidString, message: message, isIncoming: isIncoming)
            messages.append(messageModel)
        }
        self.dataSource = ConversationDataSource(messages: messages, pageSize: 20)
    }
    
    func displayConnectSocket(viewModel: Conversation.ViewModel) {
        
    }
    
    func displayMessageSent(viewModel: Conversation.ViewModel) {
        if let messageSent = viewModel.message {
            dataSource.addTNChatMessage(message: messageSent, isIncoming: false)
        }
        inputBarView.inputText = ""
    }
    
    func displayMessageReceived(viewModel: Conversation.ViewModel) {
        if let messageSent = viewModel.message {
            dataSource.addTNChatMessage(message: messageSent, isIncoming: true)
        }
    }
}

extension ConversationViewController: ConversationPhotoMessageDelegate {
    
    func conversationPhotoMessage(presenter: ConversationPhotoMessagePresenter) {
        let postModel = presenter.photoMessageModel.postModel
        router.navigateToPostDetails(postModel!)
    }
    
}
