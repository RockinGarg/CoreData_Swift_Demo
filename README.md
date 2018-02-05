# CoreData_Swift_Demo
Sample project Created To Give Basic Information of how to make use of Core Data

**This Project Consists -**

* Seprate Core Class , That managed All the required Operations in Core data
* Updating , Deleting, Creating and Finding a Record
* Looking for a Record With NSManagedObjet ID

# Relevant Code

**Get NSManaged Object Conetxt**

    func getContext() -> AudioDetail
    {
        // Create an instance of the service.
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        //get Context from Class created
        let AudioService = AudioDetail(context: context)
        return AudioService
    }
    
 **Saving a New Record**
 
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

# Basic UI

![screen shot 2018-02-05 at 12 40 34 pm](https://user-images.githubusercontent.com/26831784/35792337-97a78980-0a72-11e8-9aef-b3315bf74028.png)
