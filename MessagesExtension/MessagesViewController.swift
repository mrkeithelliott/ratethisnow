//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Keith Elliott on 10/17/16.
//  Copyright © 2016 GittieLabs. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        presentRatingsViewController(for: conversation, with: self.presentationStyle)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        guard let conversation = activeConversation else { fatalError("Expected an active converstation") }
        
        presentRatingsViewController(for: conversation, with: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

    func presentRatingsViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle){
        let viewcontroller : UIViewController
        if presentationStyle == .compact{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: RTNRatingsViewController.storyboardIdentifier) as? RTNRatingsViewController else { fatalError("expected view controller") }
            vc.delegate = self
            viewcontroller = vc
        }
        else{
            let rating = RTNItem(message: conversation.selectedMessage) ?? RTNItem()
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: RTNCreateRatingViewController.storyboardIdentifier) as? RTNCreateRatingViewController else { fatalError("expected create view controller") }
            
            vc.ratedItem = rating
            vc.conversation = conversation
            vc.delegate = self
            viewcontroller = vc
        }
        
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        addChild(viewcontroller)
        
        viewcontroller.view.frame = view.bounds
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewcontroller.view)
        
        viewcontroller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewcontroller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewcontroller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewcontroller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        viewcontroller.didMove(toParent: self)
    }
    
    fileprivate func composeMessage(with ratedItem: RTNItem, layoutImg: UIImage?, session: MSSession? = nil) -> MSMessage? {
        var components = URLComponents()
    
        guard let decodedCaption = ratedItem.caption else { return nil }
        let caption = URLQueryItem(name: "caption", value: decodedCaption)
        
        guard let decodedRating1 = ratedItem.rating1 else { return nil }
        let rating1 = URLQueryItem(name: "rating1", value: decodedRating1.rawValue)
        
        guard let decodedRating2 = ratedItem.rating2 else { return nil }
        let rating2 = URLQueryItem(name: "rating2", value: decodedRating2.rawValue)
        
        let layout = MSMessageTemplateLayout()
        
        guard let image = layoutImg else { return nil }
        layout.image = image
        
        components.queryItems = [caption, rating1, rating2]
        
        let message = MSMessage(session: session ?? MSSession())
        
        if let conversation = activeConversation,
            let msg = conversation.selectedMessage{
            if msg.senderParticipantIdentifier == conversation.localParticipantIdentifier {
                layout.caption =  "$\(msg.senderParticipantIdentifier.uuidString) rated it \(ratedItem.rating1!)"
            }
            else{
                layout.caption =  "$\(msg.senderParticipantIdentifier.uuidString) rated it \(ratedItem.rating2!)"
            }
        }
    
        message.url = components.url!
        message.layout = layout

        return message
    }
}

extension MessagesViewController: RTNRatingsViewControllerDelegate {
    func didSelectRatingsItem() {
        requestPresentationStyle(.expanded)
    }
}

extension MessagesViewController: RTNCreateRatingViewControllerDelegate {
    func addRatingForItem(_ item: RTNItem, layoutImg: UIImage?) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }

        guard let message = composeMessage(with: item, layoutImg: layoutImg, session: conversation.selectedMessage?.session)
            else { return }
        
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        
        dismiss()
    }
}
