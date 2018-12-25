//
//  ConversationInputBarView.swift
//  ThueNha
//
//  Created by LTD on 12/7/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import ChattoAdditions

public protocol ConversationInputBarViewDelegate: class {
    //func inputBarShouldBeginTextEditing(_ inputBar: ConversationInputBarView) -> Bool
    //func inputBarDidBeginEditing(_ inputBar: ConversationInputBarView)
    //func inputBarDidEndEditing(_ inputBar: ConversationInputBarView)
    //func inputBarDidChangeText(_ inputBar: ConversationInputBarView)
    func inputBarSendButtonPressed(_ inputBar: ConversationInputBarView)
    //func inputBar(_ inputBar: ConversationInputBarView, shouldFocusOnItem item: ChatInputItemProtocol) -> Bool
    //func inputBar(_ inputBar: ConversationInputBarView, didReceiveFocusOnItem item: ChatInputItemProtocol)
    //func inputBarDidShowPlaceholder(_ inputBar: ConversationInputBarView)
    //func inputBarDidHidePlaceholder(_ inputBar: ConversationInputBarView)
}

open class ConversationInputBarView: ReusableXibView {
    
    @IBOutlet weak var inputBackgroundView: UIView?
    @IBOutlet weak var inputTextView: ExpandableTextView?
    @IBOutlet weak var inputSendButton: UIButton?
    
    public weak var delegate: ConversationInputBarViewDelegate?
    
    public var shouldEnableSendButton = { (inputBar: ConversationInputBarView) -> Bool in
        guard let text = inputBar.inputTextView?.text else {
            return false
        }
        return !text.isEmpty
    }
    
    public var maxCharactersCount: UInt? // nil -> unlimited
    
    class open func loadNib() -> ConversationInputBarView {
        let view = Bundle(for: self).loadNibNamed(self.nibName(), owner: nil, options: nil)!.first as! ConversationInputBarView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect.zero
        return view
    }
    
    class func nibName() -> String {
        return "ConversationInputBarView"
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        inputBackgroundView?.backgroundColor = UIColor.thueNhaOrange
        inputBackgroundView?.layer.cornerRadius = 16.0
        inputBackgroundView?.clipsToBounds = true
        
        inputTextView?.delegate = self
        inputTextView?.placeholderDelegate = self
        inputTextView?.font = UIFont.thueNhaOpenSansRegular(size: 14)
        
        inputSendButton?.isEnabled = false
    }
    
    @IBAction func touchupInsideSend(_ sender: UIButton) {
        self.delegate?.inputBarSendButtonPressed(self)
    }
    
    public var inputText: String {
        get {
            return self.inputTextView?.text ?? ""
        }
        set {
            self.inputTextView?.text = newValue
            self.updateSendButton()
        }
    }
    
    public var inputSelectedRange: NSRange {
        get {
            return self.inputTextView?.selectedRange ?? NSRange()
        }
        set {
            self.inputTextView?.selectedRange = newValue
        }
    }
    
    public var placeholderText: String {
        get {
            return self.inputTextView?.placeholderText ?? ""
        }
        set {
            self.inputTextView?.placeholderText = newValue
        }
    }
    
    fileprivate func updateSendButton() {
        inputSendButton?.isEnabled = self.shouldEnableSendButton(self)
    }
    
}

// MARK: - UITextViewDelegate

extension ConversationInputBarView: UITextViewDelegate {

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.updateSendButton()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn nsRange: NSRange, replacementText text: String) -> Bool {
        guard let range = self.inputTextView?.text.bma_rangeFromNSRange(nsRange) else {
            return true
        }
        
        if let maxCharactersCount = self.maxCharactersCount {
            let currentCount = textView.text.count
            let rangeLength = textView.text[range].count
            let nextCount = currentCount - rangeLength + text.count
            return UInt(nextCount) <= maxCharactersCount
        }
        return true
    }
    
}

// MARK: - ExpandableTextViewPlaceholderDelegate

extension ConversationInputBarView: ExpandableTextViewPlaceholderDelegate {
    
    public func expandableTextViewDidShowPlaceholder(_ textView: ExpandableTextView) {
        
    }
    
    public func expandableTextViewDidHidePlaceholder(_ textView: ExpandableTextView) {
        
    }
}

private extension String {
    
    func bma_rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index> {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return  self.startIndex..<self.startIndex }
        return from ..< to
    }
}
