//
//  ListingProductViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire
import SwiftyJSON
import SnapKit


class ListingProductViewController: BaseViewController {
    
//    @IBOutlet weak var sliderUIView: SliderCell!
    @IBOutlet var mFilterView: UIView!
    @IBOutlet weak var listProductTableView: UITableView!
//    @IBOutlet weak var provinceUiView: ProvinceCell!
    var viewNaviCenter : UIView?
    let backButton: UIButton = UIButton()
    let titleBarLabel: UILabel = UILabel()
    let selectAccountButton: UIButton = UIButton()
    var infoButton: UIButton = UIButton()
    var serviceName: String!
    var idService = "1"
    var idDistrict = ""
    var productArray = [ProductData]()
    var resultFilter = [ProductData]()
    var selectedID : Int?
    var mAvgPrice: String = ""
    var mUtilitiesIds: String = ""
    @IBOutlet weak var mProvinceBtn: UIButton!
    @IBOutlet weak var mDistrictTF: UITextField!
    var isApplyDistrict = false
    @IBOutlet weak var mAddressView: UIView!
    @IBOutlet weak var mTypePrice: UITextField!
    
    @IBOutlet var mFilterLbl: UILabel!
    @IBOutlet weak var mResetFilter: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        sliderUIView.delegate = self
//        provinceUiView.delegate = self
        setupTableView()
        configNavigationBar()
        //Set new value for idService & idDistrict before call callServiceGetListProduct
        self.updateData()
        self.mDistrictTF.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        self.mDistrictTF.leftViewMode = .always
        self.mTypePrice.becomeFirstResponder()
        self.mTypePrice.tintColor = #colorLiteral(red: 0.1764705882, green: 0.6980392157, blue: 0.3647058824, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.isApplyDistrict) {
            if let city = UserDefaults.standard.getLastSelectedDistrict() {
                idDistrict = city["id"] ?? "0"
                self.updateData()
                self.mDistrictTF.text = city["name"] ?? ""
                
            }
            if let province = UserDefaults.standard.getLastSelectedCity() {
                self.mProvinceBtn.setTitle(province["name"] ?? "Tỉnh thành", for: UIControl.State.normal)
            }
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        self.mFilterView.removeFromSuperview()
        let rightLogo = UIBarButtonItem(customView: self.mFilterView)
        self.mFilterLbl.font = UIFont.thueNhaOpenSansRegular(size: 14)
        self.mFilterLbl.textColor = UIColor(red: 63/255.0, green: 63/255.0, blue: 71/255.0, alpha: 1.0)
        self.navigationItem.rightBarButtonItem = rightLogo
        
    }
    
    @IBAction func doFilter(_ sender: Any) {
        self.rightButtonAction()
    }
    
    @objc func rightButtonAction() {
        
        let vc = UIStoryboard.init(name: "ListingProduct", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterListProductViewController") as? FilterListProductViewController
        vc?.listingVc = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func doShowAddress(_ sender: Any) {
        self.isApplyDistrict = true
    }
    
    func updateData() ->Void {
        if(Int(self.mAvgPrice) ?? 0 > 0 || self.mUtilitiesIds.count > 0) {
            self.callServiceGetListProductByFilter(idService: idService, idDistrict: idDistrict, price: self.mAvgPrice, id_utility: self.mUtilitiesIds)
        } else {
            self.callServiceGetListProduct(idService: idService, idDistrict: idDistrict)
        }
    }
    
    func callServiceGetListProduct(idService: String, idDistrict: String) {
        if(self.isConnectedToNetwork()){
            let urlGetListProduct: String = "http://thuenha.site/api/list_post.php?id_service=" + idService + "&id_district=" + idDistrict
            Alamofire.request(urlGetListProduct)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        print(response.result.error!)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.result.value as? [String: Any] else {
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    self.productArray.removeAll()
                    for data in json["data"] as! [Dictionary<String,AnyObject>]
                    {
                        let productData = ProductData(dict: data)
                        self.productArray.append(productData)
                    }
                    let numberOfProduct = String(self.productArray.count)
                    self.setTitleNaviagtionBar(title: numberOfProduct)
                    self.resultFilter = self.productArray
                    self.listProductTableView.reloadData()
            }
        }
        
    }
    
    func callServiceGetListProductByFilter(idService: String, idDistrict: String, price: String = "", id_utility: String = "") {
        if(self.isConnectedToNetwork()){
            var urlGetListProduct: String = "http://thuenha.site/api/filter.php?id_service=" + idService + "&id_district=" + idDistrict + "&user_id=" + UserManager.user.id()
            
            if(price.count > 0) {
                urlGetListProduct = urlGetListProduct + "&price="+price
            }
            
            if(id_utility.count > 0) {
                urlGetListProduct = urlGetListProduct + "&id_utility=" + id_utility
            }
            
            Alamofire.request(urlGetListProduct)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        print(response.result.error!)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.result.value as? [String: Any] else {
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    self.productArray.removeAll()
                    for data in json["data"] as! [Dictionary<String,AnyObject>]
                    {
                        let productData = ProductData(dict: data)
                        self.productArray.append(productData)
                    }
                    let numberOfProduct = String(self.productArray.count)
                    self.setTitleNaviagtionBar(title: numberOfProduct)
                    self.resultFilter = self.productArray
                    self.listProductTableView.reloadData()
            }
        }
        
    }
    
    func handleDataAfterSelectedSlider(minValue: Float, maxValue: Float) {
        resultFilter.removeAll()
        for data in productArray {
            if let priceValue = data.price.toFloat() {
                if priceValue > minValue  && priceValue < maxValue{
                    resultFilter.append(data)
                }
            }
        }
        //    productArray = resultFilter
        print("resultFilter",resultFilter)
        let numberOfProduct = String(self.resultFilter.count)
        self.setTitleNaviagtionBar(title: numberOfProduct)
        self.listProductTableView.reloadData()
    }
    
    func setTitleNaviagtionBar(title: String) {
        let titleLabel = UILabel()
        let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                                                        .foregroundColor: UIColor(red: 63.0 / 255.0, green: 63.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)]
        let secondAttr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                                                         .foregroundColor: UIColor.red]
        let thirtAttr: [NSAttributedString.Key: Any] = [.font: UIFont(name: "OpenSans-Semibold", size: 18.0)!,
                                                        .foregroundColor: UIColor(red: 63.0 / 255.0, green: 63.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)]
        let attrString = NSMutableAttributedString(string: "\(self.serviceName ?? "") có", attributes: firstAttr)
        let secondAttrString = NSAttributedString(string: " " + title, attributes: secondAttr)
        let thirtAttrString = NSAttributedString(string: " tin đăng", attributes: thirtAttr)
        attrString.append(secondAttrString)
        attrString.append(thirtAttrString)
        titleLabel.attributedText = attrString
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        titleLabel.adjustsFontSizeToFitWidth = true
        navigationItem.titleView = titleLabel
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    func setupTableView() {
        listProductTableView.dataSource = self
        listProductTableView.delegate = self
        listProductTableView.separatorStyle = .none
        listProductTableView.estimatedRowHeight = 30
        listProductTableView.rowHeight = UITableView.automaticDimension
        listProductTableView.tableFooterView = UIView()
        listProductTableView.register(UINib(nibName: "ListProductCell", bundle: nil), forCellReuseIdentifier: "ListProductCell")
        listProductTableView.register(UINib(nibName: "NoProductCell", bundle: nil), forCellReuseIdentifier: "NoProductCell")
    }
    
    @IBAction func doResetFilter(_ sender: Any) {
        self.isApplyDistrict = false
        self.mDistrictTF.text = ""
        self.mProvinceBtn.setTitle("Tỉnh thành", for: UIControl.State.normal)
        idDistrict = "0"
        self.mUtilitiesIds = ""
        self.mAvgPrice = ""
        self.mTypePrice.text = ""
        self.updateData()
        
    }
    
    @IBAction func didTapOutside(_ sender: UITapGestureRecognizer) {
        
        if(self.mTypePrice.isFirstResponder) {
            self.mTypePrice.resignFirstResponder()
        }
        
    }
    
}

extension ListingProductViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ListProductCell = listProductTableView.dequeueReusableCell(withIdentifier: "ListProductCell")! as! ListProductCell
        if !resultFilter.isEmpty {
            cell.loadCell(productObject: resultFilter[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !resultFilter.isEmpty else { return }
        
        let data : ProductData = productArray[indexPath.row]
        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        productDetailVC.post_id = data.id
        self.navigationController?.pushViewController(productDetailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListingProductViewController: ProvinceCellDelegate {
    func handleActionTapOnCloseButton() {
        //Set new value for idService & idDistrict before call callServiceGetListProduct
        self.updateData()
    }
    
    func handleActionTapOnSearchProvinceButton() {
//        self.alertInDevelopmentFeature()
    }
    
    func handleActionTapOnProvinceButton() {
//        self.alertInDevelopmentFeature()
    }
}

extension ListingProductViewController: SliderCellDelegate {
    func handleActionSelectSlider(minValue: Float, maxValue: Float) {
        handleDataAfterSelectedSlider(minValue: minValue, maxValue: maxValue)
    }
}

extension ListingProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text as NSString? {
            var txtAfterUpdate = text.replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespaces)
            txtAfterUpdate = txtAfterUpdate.replacingOccurrences(of: ".", with: "")
            txtAfterUpdate = txtAfterUpdate.replacingOccurrences(of: ",", with: "")
            if(txtAfterUpdate.isNumber && txtAfterUpdate.count < 12){
                self.mAvgPrice = txtAfterUpdate
                txtAfterUpdate = (Int(txtAfterUpdate)?.withCommas())!
                textField.text = txtAfterUpdate
                self.updateData()
                return false
            }
            self.mAvgPrice = ""
            self.updateData()
            return txtAfterUpdate.isEmpty || (txtAfterUpdate.isNumber && txtAfterUpdate.count < 12)
            
        }
        self.mAvgPrice = ""
        self.updateData()
        return true
    }
    
}

extension UIViewController {
    
    func transparentNavigationBar(withColor color: UIColor = .white) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = color
    }
    
}

public struct Utility {
    
    public var active : String!
    public var avatar : String!
    public var content : String!
    public var date : String!
    public var id : String!
    public var img : String!
    public var name : String!
    public var number : String!
    public var position : String!
    
}

public struct ProductData {
    
    public var active : String!
    public var address : String!
    public var area : String!
    public var avatar : String!
    public var city : String!
    public var cityId : String!
    public var content : String!
    public var date : String!
    public var district : String!
    public var districtId : String!
    public var hostId : String!
    public var id : String!
    public var idService : String!
    public var idUtility : String!
    public var note : String!
    public var numberBed : String!
    public var numberWc : String!
    public var price : String!
    public var title : String!
    public var type : String!
    public var utility : [Utility]!
    
    init(dict: [String: Any]) {
        self.active = dict.parseString("active")
        self.address = dict.parseString("address")
        self.area = dict.parseString("area")
        self.avatar = dict.parseString("avatar")
        self.city = dict.parseString("city")
        self.cityId = dict.parseString("cityId")
        self.content = dict.parseString("content")
        self.date = dict.parseString("date")
        self.district = dict.parseString("district")
        self.districtId = dict.parseString("districtId")
        self.id = dict.parseString("id")
        
        self.idService = dict.parseString("idService")
        self.idUtility = dict.parseString("idUtility")
        self.note = dict.parseString("note")
        self.numberBed = dict.parseString("numberBed")
        self.price = dict.parseString("price")
        self.title = dict.parseString("title")
        self.type = dict.parseString("type")
        //    self.utility = dict.parseString("utility")
    }
    
}

extension Dictionary {
    func parseString(_ key: String) -> String {
        guard let dict = self as? [String: AnyObject] ,let value = dict[key] as? String else { return "" }
        return value
    }
}

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed,bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}



