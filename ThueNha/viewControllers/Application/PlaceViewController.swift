//
//  PlaceViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/13/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

enum PlaceTableViewType : Int {
    case placeView = 1
    case subPlaceView = 2
}

class PlaceTableViewCell : UITableViewCell {
    
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var mImage: UIImageView!
}

class AddressInfo {
    var mCityId : String = ""
    var mDistrictID : String = ""
}

class PlaceViewController: BaseViewController {

    @IBOutlet weak var mSubPlaceView: UITableView!
    @IBOutlet weak var mPlaceView: UITableView!
    @IBOutlet weak var mSearchView: UIView!
    @IBOutlet weak var mPlaceSearchField: UITextField!
    @IBOutlet weak var mPlaceBtn: UIButton!
    
    
    @IBOutlet weak var mPlaceViewShadow: UIView!
    var cities : Array<Dictionary<String, String>> = []
    var districts : Array<Dictionary<String, String>> = []
    var sortedDistricts : Array<Dictionary<String, String>> = []
    var selectedAddress : AddressInfo = AddressInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cityData = UserDefaults.standard.getJSON("thuenha_cities")
        if let city : Array<Dictionary<String, String>> = cityData.arrayObject as? Array<Dictionary<String, String>> {
            cities.append(contentsOf: city)
        }
        if let lastSelected = UserDefaults.standard.getLastSelectedCity()  {
            selectedAddress.mCityId = lastSelected["id"]!
            let name = lastSelected["name"]!
            self.mPlaceBtn.setTitle(name, for: .normal)
            self.loadDistrictOf(city: selectedAddress.mCityId) {
                
            }
        }
        NetworkManager.shareInstance.apiGetCities { (data, messge, isSuccess) in
            if(isSuccess) {
                self.saveCitiesData((data as! JSON).arrayObject!, model: &self.cities, view: &self.mPlaceView, key: "thuenha_cities")
            }
            
        }
        mPlaceViewShadow.layer.shadowColor = UIColor.black.cgColor
        mPlaceViewShadow.layer.shadowOpacity = 1
        mPlaceViewShadow.layer.shadowOffset = CGSize.zero
        mPlaceViewShadow.layer.shadowRadius = 10
        
        mPlaceSearchField.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 10))
        mPlaceSearchField.leftView?.backgroundColor = UIColor(red: 254/255.0, green: 241/255.0, blue: 234/255.0, alpha: 1.0)
        mPlaceSearchField.leftViewMode = .always

        
    }
    
    func saveCitiesData(_ cityData: Array<Any>, model : inout Array<Dictionary<String, String>>, view: inout UITableView, key : String) {
        model.removeAll()
        self.reloadTableViewInMain(view)
        for i in 0..<cityData.count {
            var object = cityData[i] as! Dictionary<String, Any>

            if (object["ordering"] as? String) == nil {
                object["ordering"] = "-1"
            }
            model.append(object as! Dictionary<String, String>)
        }
        
        model.sort { (this, that) -> Bool in
            self.reloadTableViewInMain(view)
            if(this["ordering"] == "-1") {
                return false
            }
            if(that["ordering"] == "-1") {
                return true
            }
            return Int(this["ordering"]!) ?? 0 < Int(that["ordering"]!) ?? 0
        }
        
        let data = JSON(model)
        UserDefaults.standard.saveJSON(json: data, key: key)
        self.reloadTableViewInMain(view)
    }
    
    func loadDistrictOf(city cityId : String, callback callBack: @escaping () -> ()) {
        let key = String(format:"thuenha_%@_districts", cityId)
        let districtData = UserDefaults.standard.getJSON(key)
        if let district : Array<Dictionary<String, String>> = districtData.arrayObject as? Array<Dictionary<String, String>> {
            self.districts.append(contentsOf: district)
            self.reloadTableViewInMain(self.mSubPlaceView)
            callBack()
        }
        NetworkManager.shareInstance.apiGetDistricts(cityId) { (data, messge, isSuccess) in
            if(isSuccess) {
                self.saveCitiesData((data as! JSON).arrayObject!, model: &self.districts, view: &self.mSubPlaceView, key: key)
                callBack()
            }
        }
    }
    
    func reloadTableViewInMain(_ tableView : UITableView){
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    @IBAction func pressPlaceBtn(_ sender: UIButton) {
        self.mPlaceView.isHidden = false
        self.mPlaceViewShadow.isHidden = false
        self.view.bringSubviewToFront(self.mPlaceViewShadow)
        self.view.bringSubviewToFront(self.mPlaceView)
        self.reloadTableViewInMain(self.mPlaceView)
        
    }
    
    func _districts() -> Array<Dictionary<String, String>> {
        if (self.mPlaceSearchField.text != nil && self.mPlaceSearchField.text?.count ?? 0 > 0) {
            return self.sortedDistricts
        }
        return self.districts
    }
    
    @IBAction func textFieldDidchanged(_ sender: UITextField) {
        self.sortedDistricts.removeAll()
        self.reloadTableViewInMain(self.mSubPlaceView)
        if let text = sender.text {
            for obj in self.districts {
                if let name = obj["name"] {
                    if(name.lowercased().range(of: text.lowercased()) != nil) {
                        self.sortedDistricts.append(obj)
                    }
                }
            }
            self.reloadTableViewInMain(self.mSubPlaceView)
        }
    }
    
    @IBAction func doAbort(_ sender: Any?) {
        self.dismiss(animated: true) {
            
        }
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

extension PlaceViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data : Dictionary<String, String>
        if(tableView.tag == PlaceTableViewType.placeView.rawValue) {
            data = cities[indexPath.row]
            UserDefaults.standard.setLastSelectedCity(data)
            let cityName = data["name"]
            self.selectedAddress.mCityId = data["id"]!
            DispatchQueue.global(qos: .background).async {
                self.loadDistrictOf(city: self.selectedAddress.mCityId) {
                    DispatchQueue.main.async {
                        self.mPlaceBtn.setTitle(cityName, for: .normal)
                        tableView.isHidden = true
                        self.view.sendSubviewToBack(tableView)
                        self.mPlaceViewShadow.isHidden = true
                        self.view.sendSubviewToBack(self.mPlaceViewShadow)
                    }
                }
            }
            
        } else {
            data = self._districts()[indexPath.row]
            UserDefaults.standard.setLastSelectedDistrict(data)
            self.doAbort(tableView)
        }
    }
    
}

extension PlaceViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int = 0
        if(tableView.tag == PlaceTableViewType.placeView.rawValue) {
            count = self.cities.count
        } else if (tableView.tag == PlaceTableViewType.subPlaceView.rawValue) {
            count = self._districts().count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        var data : Dictionary<String, String>
        if(tableView.tag == PlaceTableViewType.placeView.rawValue) {
            data = cities[indexPath.row]
        } else {
            cell.mImage.isHidden = false
            let source = self._districts()
            data = source[indexPath.row]
            
        }
        
        cell.placeLbl.text = data["name"]
        return cell
    }
    
    
    
    
}
