//
//  ViewController.swift
//  easemod-uikit
//
//  Created by Max Cobb on 17/09/2021.
//

import UIKit
import AgoraUIKit_iOS
import AgoraRtcKit
import EaseIMKit

class ViewController: UIViewController {

    var agView: AgoraVideoViewer?
    var chatController: EaseChatViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        var agSettings = AgoraSettings()

        agSettings.enabledButtons = [.micButton, .cameraButton, .flipButton]
        self.agView = AgoraVideoViewer(
            connectionData: AgoraConnectionData(appId: AppKeys.agoraAppId),
            agoraSettings: agSettings, delegate: self
        )

        self.agView?.fills(view: self.view)
        self.agView?.join(channel: "test", with: AppKeys.agoraToken, as: .broadcaster)

        self.setupEasemobVC()
    }
    func setupEasemobVC() {
        EaseIMKitManager.initWith(EMOptions(appkey: AppKeys.easemodKey)!)
        EMClient.shared().login(
            withUsername: AppKeys.easemodUsername, token: AppKeys.easemodToken
        ) { username, err in

        }
        let viewModel = EaseChatViewModel()
        let chatcontroller = EaseChatViewController.initWithConversationId(
            "custom", conversationType: EMConversationTypeChat, chatViewModel: viewModel
        )
        chatcontroller.delegate = self
        chatcontroller.tableView.refreshControl = nil
        self.chatController = chatcontroller
    }

    @objc func showChat(sender: UIButton) {
        self.present(self.chatController!, animated: true, completion: nil)
    }
}

class User: NSObject, EaseUserDelegate {
    var easeId: String = "example"
}

extension ViewController: AgoraVideoViewerDelegate {
    func extraButtons() -> [UIButton] {
        let button = UIButton()
        button.setImage(UIImage(systemName: "envelope"), for: .normal)
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(showChat(sender:)), for: .touchUpInside)
        return [button]
    }
}

extension ViewController: EaseChatViewControllerDelegate {
    func userData(_ huanxinID: String) -> EaseUserDelegate {
        User()
    }
}
