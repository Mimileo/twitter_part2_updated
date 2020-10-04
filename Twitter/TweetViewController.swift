//
//  TweetViewController.swift
//  Twitter
//
//  Created by Mireya Leon on 9/30/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tweet(_ sender: Any) {
    
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       // TODO: Check the proposed new text character count
       // Allow or disallow the new text
        // Set the max character limit
        //let characterLimit = 280

        // Construct what the new text would be if we allowed the user's latest edit
        //let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

        // TODO: Update Character Count Label

        // The new text should be allowed? True/False
       // return newText.count < characterLimit
        
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        //guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let characterLimit = 280
        let updatedText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // update character count label
        countLabel.text = "( \(updatedText.count) \\ 280 )"

        // make sure the result is under 16 characters
        if updatedText.count == 280 {
            countLabel.textColor = UIColor.red
        }
        return updatedText.count < characterLimit
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
