//
//  ViewController.swift
//  AppCoreData
//
//  Created by IosDeveloper on 28/12/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var fileNameTF: UITextField! {
        didSet {
            fileNameTF.delegate = self
            fileNameTF.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var durationTF: UITextField! {
        didSet {
            durationTF.delegate = self
            durationTF.returnKeyType = .next
        }
    }
    
    @IBOutlet weak var statusTF: UITextField! {
        didSet {
            statusTF.delegate = self
            statusTF.returnKeyType = .done
        }
    }
}

//MARK:- View Life Cycles
extension ViewController
{
    //MARK: Did Load
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    //MARK: Memory Warnings
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Custom Functions
extension ViewController
{
    //MARK: Get Common Context for Core Data
    func getContext() -> AudioDetail
    {
        // Create an instance of the service.
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        //get Context from Class created
        let AudioService = AudioDetail(context: context)
        return AudioService
    }
    
    //MARK: Check text Exists
    func doTextExists(TF:UITextField)->Bool
    {
        if TF.text?.trimmingCharacters(in: .whitespaces) != ""
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: Basic Alert
    func BasicAlert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Button Actions
extension ViewController
{
    //MARK: Save a new record
    @IBAction func saveNewRecord(_ sender: Any)
    {
        if (self.doTextExists(TF: fileNameTF)) && (self.doTextExists(TF: durationTF)) && (self.doTextExists(TF: statusTF))
        {
            let AudioService = self.getContext()
            _ = AudioService.create(fileName: fileNameTF.text!, duration: durationTF.text!, uploadedStatus: statusTF.text!)
        }
        else
        {
            self.BasicAlert("Error!", message: "All Fields Are Necessary", view: self)
        }
    }
    
    //MARK: Update a record
    @IBAction func updateARecord(_ sender: Any)
    {
        //nsmanagedObjectId
        var Id = NSManagedObjectID()
        
        //get context
        let AudioService = self.getContext()
        
        //get all values
        let allRecords : [Audio] = AudioService.getAll()
        
        //loop through array
        for i in 0..<allRecords.count
        {
            //get Record at index i
            let record = allRecords[i]
            
            //if index filename matches
            if record.fileName == fileNameTF.text!
            {
                Id = allRecords[i].objectID
                print(allRecords[i].objectID)
            }
            else
            {
                showToast(message: "Record not Found")
                return
            }
        }
        
        //get Audio file ref for specific id
        let AudioFileForId = AudioService.getById(id: Id)
        
        //Upload status here
        //for now static can be made Dynamic
        AudioFileForId?.uploadedStatus = "False"
     
        //Update file
        AudioService.update(updatedPerson: AudioFileForId!) { (success) in
            if (success)
            {
                showToast(message: "Values Updated")
            }
            else
            {
                showToast(message: "Values Not Updated")
            }
        }
    }
    
    //MARK: Get All Records
    @IBAction func getAllRecords(_ sender: Any)
    {
        //get context
        let AudioService = self.getContext()

        //get all values
        let allRecords : [Audio] = AudioService.getAll()
     
        if allRecords.count == 0
        {
            showToast(message: "No DB Added")
            return
        }
        else
        {
            //loop through array
            for record in allRecords
            {
                //Print name
                print(record.fileName!)
            }
        }
    }
    
    //MARK: Delete All Saved Records
    @IBAction func deleteAllRecords(_ sender: Any)
    {
        let AudioService = self.getContext()
      
        //get all values
        let allRecords : [Audio] = AudioService.getAll()
        
        if allRecords.count == 0
        {
            showToast(message: "No DB Added")
            return
        }
        else
        {
            AudioService.deleteAllData(entity: "Audio") { (success) in
                if (success)
                {
                    showToast(message: "Records Deleted")
                }
                else
                {
                    showToast(message: "Records Not Deleted")
                }
            }
        }     
    }
    
}

//MARK:- UITextField Extension
extension ViewController : UITextFieldDelegate
{
    //MARK: TF Return Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case fileNameTF:
            durationTF.becomeFirstResponder()
        case durationTF:
            statusTF.becomeFirstResponder()
        case statusTF:
            statusTF.resignFirstResponder()
            self.view.endEditing(true)
        default:
            self.view.endEditing(true)
        }
        return true
    }
}

//MARK:- Extension For UIViewController
extension UIViewController
{
    //MARK: Add a toast message on Screen
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

