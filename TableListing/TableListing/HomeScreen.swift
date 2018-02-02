//
//  HomeScreen.swift
//  TableListing
//
//  Created by Ajay S Moorthy on 19/01/18.
//  Copyright © 2018 myyshopp. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController {
    @IBOutlet weak var tblListView:UITableView!
    private var listArray:[[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listArray = []
        // Do any additional setup after loading the view, typically from a nib.
        WebServiceAPI.trialWebService(["storeId":"4" as AnyObject], onSuccess: { (result) in
            debugPrint("Result --> ", result)
            self.listArray = (result["result"]!["PaymentOptions"] as! [[String:AnyObject]])
            self.tblListView.reloadData()
        }) { (error) in
            debugPrint("Error --> ", error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension HomeScreen:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? UITableViewCell else {
            return UITableViewCell()
        }
        debugPrint("### \(listArray[indexPath.row]["title"] as? String) ###")
        cell.textLabel?.text = listArray[indexPath.row]["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("The item selected is --> ",listArray[indexPath.row]["title"])
    }
}

