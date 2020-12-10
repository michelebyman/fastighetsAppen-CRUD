//
//  SMSSender.swift
//  fastighetsAppen
//
//  Created by Michele Byman on 2020-12-10.
//

import Foundation
import MessageUI

class SMSSender : NSObject, MFMessageComposeViewControllerDelegate
{
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    func sendSMS(sendTo : [String])
    {
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = self
        messageVC.body = "Message String"
        messageVC.recipients = sendTo // Optionally add some tel numbers
        topMostController().present(messageVC, animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        topMostController().dismiss(animated: true, completion: nil)
    }
    
    
}
