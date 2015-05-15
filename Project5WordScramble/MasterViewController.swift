//
//  MasterViewController.swift
//  Project5WordScramble
//
//  Created by Henry on 5/14/15.
//  Copyright (c) 2015 Henry. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    var allWords = [String]()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Finding a path to a file, even though we know the file is called "start.txt", we don't know where it might be on the filesystem
        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            //Loading a file into a string, when we create an NSString instance, we can ask it to create itself from the contents of a file at a particular path.We can also provide it with parameters to tell the text encoding that was used and whether an error occurred
            if let startWords = NSString(contentsOfFile: startWordsPath, usedEncoding: nil, error: nil) {
                //We need to split our single string into an array of strings based on wherever we find a line break (\n)
                allWords = startWords.componentsSeparatedByString("\n") as! [String]
            }
        }
        else {
            allWords = ["silkworm"]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        
        startGame()
    }
    
    func startGame() {
        //Array has been shuffled
        allWords.shuffle()
        //Sets our view controller's title to be the first word in the array
        title = allWords[0]
        //Removes all values from the objects array.The array was created by the Xcode template, and we'll be using it to store the player's answers
        objects.removeAll(keepCapacity: true)
        //Cause the table view to check how many rows it has and reload them all
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        //Just adds an editable text field to the UIAlertController
        alertController.addTextFieldWithConfigurationHandler(nil)
        //It's a trailing closure syntax
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, alertController] (action: UIAlertAction!) in
            //Add a single text field to the UIAlertController
            let answer = alertController.textFields![0] as! UITextField
            self.submitAnswer(answer.text)
        }
        //Is used to add a UIAlertAction to a UIAlertController
        alertController.addAction(submitAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
        //check the player's answer we immediately lowercase it using its lowercaseString property
        let lowerAnswer = answer.lowercaseString
        
        if wordIsPossible(lowerAnswer) {
            if wordIsOriginal(lowerAnswer) {
                if wordIsReal(lowerAnswer) {
                    //Add it to the start of the array, and the newest words will appear at the top of the table view.
                    objects.insert(answer, atIndex: 0)
                    
                    //As it contains a section and a row for every item in table
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    //Let us tell the table view that a new row has been placed at a specific place in the array so that it can animate the new cell appearing
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
                else {
                    let alertController = UIAlertController(title: "Word not recognized", message: "You can't just make them up", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alertController, animated: true, completion: nil)
                }
            }
            else {
                let alertController = UIAlertController(title: "Word used already", message: "Be more original", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else {
            //Show the view controller's title as a lowercase string
            let alertController = UIAlertController(title: "Word not possible", message: "You can't spell that word from \(title!.lowercaseString)", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func wordIsPossible(word: String) -> Bool {
        var tempWord = title!.lowercaseString
        
        for letter in word {
            //rangeOfString() returns an optional position of where the item was found, and rangeOfString() expects a string, not a character, so we need to create a string from the character
            if let wordPosition = tempWord.rangeOfString(String(letter)) {
                if wordPosition.isEmpty {
                    return false
                }
                else {
                    //To remove the used letter from the tempWord variable
                    tempWord.removeAtIndex(wordPosition.startIndex)
                }
            }
            else {
                return false
            }
        }
        return true
    }
    
    func wordIsOriginal(word: String) -> Bool {
        //If it does contain the value, contains() returns true; if not, it returns false
        return !contains(objects, word)
    }
    
    func wordIsReal(word: NSString) -> Bool {
        //An iOS class that is designed to spot spelling errors, which makes it perfect for knowing if a given word is real or not.
        let checker = UITextChecker()
        //This is used to make a string range, which is a value that holds a start position and a length.
        let range = NSMakeRange(0, word.length)
        //The first parameter is our string, the second is our range to scan, and the last is the language we should be checking with, where en selects English
        let misspelledRange = checker.rangeOfMisspelledWordInString(word as String, range: range, startingAt: 0, wrap: false, language: "en")
        if misspelledRange.location == NSNotFound {
            return true
        }
        else {
            return false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

}

