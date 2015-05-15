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

