//
//  StartViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/5/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

class ServiceCollectionCell: UICollectionViewCell {

    @IBOutlet weak var mImage: UIImageView!
    
    @IBOutlet weak var mLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        backgroundColor = UIColor.white
        mImage.layer.masksToBounds = true
//        mImage.layer.cornerRadius = 8
        mImage.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
}



class StartViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var mSliderView: iCarousel!
    @IBOutlet weak var mPageControl: UIPageControl!
    @IBOutlet weak var mPostBtn: UIButton!
    
    @IBOutlet weak var mAccount: UILabel!
    @IBOutlet weak var mAccountType: UILabel!
    
    var mBackgroundImages : Array<Dictionary<String, String>> = []
    var mServicesList : Array<Dictionary<String, String>> = []
    var mAutoReloadData : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSLog("bounds = \(self.view.bounds)")
        let width = self.view.bounds.size.width
        let padding = (width - 89 * 3) / 3
        
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 3,
            minimumInteritemSpacing: padding/3,
            minimumLineSpacing: padding,
            sectionInset: UIEdgeInsets(top: padding/2, left: padding/2, bottom: padding/2, right: padding/2)
        )
        mCollectionView?.collectionViewLayout = columnLayout
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mSliderView.isPagingEnabled = true
        mSliderView.type = .linear
        
        
        mPostBtn.layer.borderColor = UIColor.white.cgColor
        mPostBtn.layer.borderWidth = 1
        mPostBtn.layer.cornerRadius = 8
        
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if(mAutoReloadData) {
            self.getData()
            mAutoReloadData = false
        }
        mAccount.text = "Số dư TK: \(formatBalance(digit: UserManager.user.account().toFloat()!))"
        if(UserManager.user.type() == 1) {
            mAccountType.text = "Tài khoản: Người thuê"
        } else {
            mAccountType.text = "Tài khoản: Chủ nhà"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        mAutoReloadData = true
    }
    
    func getData() {
        self.getBackgroundApp()
        self.getService()
    }
    
    func getService(){
        
        if(self.isConnectedToNetwork()) {
            self.showHud()
            NetworkManager.shareInstance.apiGetServiceList { (data, message, isSuccess) in
                if(isSuccess) {
                    if let data = data as? JSON {
                        if var data : Array<Dictionary<String, String>> = data.arrayObject as? Array<Dictionary<String, String>> {
                            data = data.filter(self.removeInactiveItem)
                            self.mServicesList.removeAll()
                            self.mServicesList.append(contentsOf: data)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.hideHud()
                        self.mCollectionView.reloadData()
                    }
                }
            }
        }

    }
    
    func getBackgroundApp() {
        if(self.isConnectedToNetwork()) {
            self.showHud()
            DispatchQueue.global(qos: .background).async {
                Alamofire.request("http://thuenha.site/api/background.php").responseJSON{ response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")                         // response serialization result
                    
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
                    
                    let jsonObj = JSON(response.result.value!)
                    if let errorId = jsonObj["errorId"].int, errorId == 200 {
                        if var data : Array<Dictionary<String, String>> = jsonObj["data"].arrayObject as? Array<Dictionary<String, String>> {
                            data.sort(by: self.sorterForFileIDESC)
                            data = data.filter(self.removeInactiveItem)
                            self.mBackgroundImages.removeAll()
                            self.mBackgroundImages.append(contentsOf: data)
                            //                        self.mBackgroundImages = data as Array<Dictionary<String, String>>
                            DispatchQueue.main.async {
                                self.reloadSlider()
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.hideHud()
                    }
                }
            }
        }
    }
    
    func reloadSlider() {
        mSliderView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ListingProductViewController") {
            let listingView = segue.destination as! ListingProductViewController
            listingView.selectedID = 1
        }
    }
 
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        var count : Int = 0
        for data in self.mBackgroundImages {
            if(Int(data["active"]!) == 1) {
                count = count + 1
            }
        }
        if (count > 0) {
            mPageControl?.numberOfPages = count
            mPageControl?.isHidden = false
        } else {
            mPageControl?.isHidden = true
        }
        return count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIImageView
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height))
            itemView.contentMode = .scaleToFill
        }
        let data = self.mBackgroundImages[index]
        let url = (data["img"])!.urlEncoded()
        NSLog("\(url)")
        itemView.sd_setImage(with: URL(string: url ), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
        
        
        return itemView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        mPageControl.currentPage = carousel.currentItemIndex
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        switch (option)
        {
        case .wrap:
            return 1
            
        default:
            return value
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mServicesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCollectionCell
        let data = self.mServicesList[indexPath.item]
        let url : String = data["img"]!
        cell.mImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "thuenha"), options: .retryFailed, completed: nil)
        cell.mLabel.text = data["name"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if UserManager.user.type() == 1 {
            let listingVC = self.storyboard?.instantiateViewController(withIdentifier: "ListingProductViewController") as! ListingProductViewController
            let data = self.mServicesList[indexPath.item]
            listingVC.idService = data["id"]!
            listingVC.serviceName = data["name"]!
            self.navigationController?.pushViewController(listingVC, animated: true)
        } else {
            self.doPostNew(indexPath)
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            changeTabBar(hidden: true, animated: true)
        }
        else{
            changeTabBar(hidden: false, animated: true)
        }
    }
    
    func changeTabBar(hidden:Bool, animated: Bool){
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
    }
    
    @IBAction func doFeedback(_ sender: UIButton) {
//        self.alertInDevelopmentFeature()
        performSegue(withIdentifier: "home_to_feedback", sender: self)
    }
    
    @IBAction func doPostNew(_ sender: Any?) {
        if(UserManager.user.type() == 2) {
            
            let postNew = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
            postNew.mServices.append(contentsOf: self.mServicesList)
            if let indexPath = sender as? IndexPath {
                let data = self.mServicesList[indexPath.item]
                postNew.mSelectedService = data["id"] ?? ""
            }
            self.navigationController?.pushViewController(postNew, animated: true)
            
        } else {
            self.alert("Tài khoản của bạn không thể thực hiện chức năng này.\nVui lòng đăng nhập với tư cách người cho thuê!")
        }
    }
    

}

extension StartViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 89, height: 105)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        var minimumSpacing : CGFloat = 10
        let deviceType = UIScreen.main.nativeBounds.height
        let page = ceil(CGFloat(mServicesList.count / 3))
        if deviceType >= 1136 {
            
            minimumSpacing = ((collectionView.frame.height - 105 * page ) - (self.tabBarController?.tabBar.frame.size.height)!) / (page+1)
            if(minimumSpacing < 10) {
                minimumSpacing = 10
            }
        }
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return (collectionView.frame.width - 89 * 3)/4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        let left = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        return UIEdgeInsets(top:top , left: left, bottom: top, right: left)
    }
    
}

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
