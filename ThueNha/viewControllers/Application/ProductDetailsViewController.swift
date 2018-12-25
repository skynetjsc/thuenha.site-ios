//
//  ProductDetailsViewController.swift
//  ThueNha
//
//  Created by Lan Tran Duc on 12/5/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwifterSwift

class ProductDetailsViewController: BaseViewController {
    
    
    @IBOutlet weak var imgAvatarUser: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblTitlePostNewAddress: UILabel!
    @IBOutlet weak var lblTitleAddress: UILabel!
    @IBOutlet weak var lblContentAddress: UILabel!
    @IBOutlet weak var lblRoomRate: UILabel!
    @IBOutlet weak var lblStatusRoom: UILabel!
    @IBOutlet weak var lblRoomArea: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContentDetailPostNews: UILabel!
    @IBOutlet weak var collectionUtilityRoomView: UICollectionView!
    @IBOutlet weak var lblPhoneUser: UILabel!
    @IBOutlet weak var mPageControl: UIPageControl!
    @IBOutlet weak var mSliderView: iCarousel!
    
    
    @IBOutlet weak var viewUserViewProduct: UIView!
    @IBOutlet weak var viewUserPostProduct: UIView!
    @IBOutlet weak var viewSelectProductDetail: UIView!
    @IBOutlet weak var btnViewProductDetail: UIButton!
    @IBOutlet weak var mBlockView: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    
    @IBOutlet weak var btnLeased: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    
    @IBOutlet weak var heightConstraintListUtilityProduct: NSLayoutConstraint!
    
    @IBOutlet weak var btnFavorite: UIButton!
    private let refreshControl = UIRefreshControl()
    var productDetail: ProductDetail!
    var listUtility: [UtilityProductDetail] = []
    var listImageProductDetail: [String] = []
    
    var post_id : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionUtilityRoomView.register(UINib.init(nibName: "ProductDetailViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ProductDetailViewCell")
        collectionUtilityRoomView.delegate = self
        collectionUtilityRoomView.dataSource = self
        mSliderView.isPagingEnabled = true
        mSliderView.type = .linear
        mSliderView.dataSource = self
        mSliderView.delegate = self
        btnViewProductDetail.layer.cornerRadius = 4
        btnChat.layer.cornerRadius = 6
        btnChat.layer.borderColor = "F76B1C".hexColor().cgColor
        btnChat.layer.borderWidth = 1
        self.scrollView.isScrollEnabled = false
        self.refreshControl.addTarget(self, action: #selector(getProductDetail), for: .valueChanged)
        self.scrollView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.setAttributeTitle()
        
        getProductDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func showPopupProductDetail(){
        
        let param = Payment_Request.init()
        param.post_id = self.post_id
        param.user_id = UserManager.user.id()
        self.view.showPopupProductDetail(title: "Xem chi tiết tin đăng", price: productDetail.price.isEmpty ? "0" : productDetail.price, type: .none, acceptBlock: {
            services.getPaymentProductDetail(param: param, success: { () in
                self.showHud()
                self.getProductDetail()
                
                self.hideHud()
            }, failure: { (error) in
                self.hideHud()
            })
        }) {
            
        }
        
    }
    
    func setDataProductDetail(){
        self.hideHud()
        self.refreshControl.endRefreshing()
        lblUserName.text = productDetail.host.name
        lblPhoneUser.text = productDetail.host.phone
        lblTitlePostNewAddress.text = productDetail.post.title
        lblContentAddress.text = productDetail.post.address
        lblRoomRate.text = formatBalance(digit: productDetail.post.price.toFloat() ?? 0) + "/Tháng"
        lblRoomArea.text = productDetail.post.area + "m2"
        lblStatusRoom.text = productDetail.post.active == "1" ? "Đang còn" : "Hết phòng"
        lblContentDetailPostNews.text = productDetail.post.content
        imgAvatarUser.sd_setImage(with: URL(string: productDetail.host.avatar), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
        imgAvatarUser.setRounded()
        if productDetail.is_favourite == 1 {
            btnFavorite.setImage("red_hearts".image(), for: .normal)
            btnLike.isSelected = true
            
        } else {
           btnFavorite.setImage("white_heart".image(), for: .normal)
            btnLike.isSelected = false
        }
        if productDetail.is_pay == 1  {
            self.viewSelectProductDetail.isHidden = true
            self.scrollView.isScrollEnabled = true
            self.mBlockView.isHidden = true
            self.mBlockView.superview?.sendSubviewToBack(self.mBlockView)
        } else {
            self.mBlockView.isHidden = false
            self.mBlockView.superview?.bringSubviewToFront(self.mBlockView)
            self.scrollView.isScrollEnabled = false
            self.viewSelectProductDetail.isHidden = false
        }
        
        if UserManager.user.id() == productDetail.host.id {
            viewUserPostProduct.isHidden = false
            viewUserViewProduct.isHidden = true
        } else {
            viewUserPostProduct.isHidden = true
            viewUserViewProduct.isHidden = false
        }
        
    }
    
    @objc func getProductDetail() {
        let param = ProductDetail_Request.init()
        param.post_id = self.post_id
        param.type = "\(UserManager.user.type())"
        param.user_id = UserManager.user.id()
        
        showHud()
        services.getProductDetail(param: param, success: { (productDetail) in
            self.productDetail = productDetail
            self.listUtility = productDetail.utility
            self.listImageProductDetail = productDetail.image
            DispatchQueue.main.async {
                self.collectionUtilityRoomView.reloadData()
                self.collectionUtilityRoomView.layoutIfNeeded()
                    self.heightConstraintListUtilityProduct.constant = self.collectionUtilityRoomView.contentSize.height
                self.mSliderView.reloadData()
                
            }
            self.setDataProductDetail()
            
        }) { (error) in
            self.hideHud()
            self.refreshControl.endRefreshing()
        }
    }
    

    
    @IBAction func tappedLeased(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ListViewerViewController") as! ListViewerViewController
        viewController.mPostId = self.post_id
        viewController.mControllerType = 2
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func tappedDeleteProduct(_ sender: Any) {
        let param = DeleteProduct_Request.init()
        param.id = self.post_id
        showHud()
        services.deleteProductDetail(param: param, success: {
            self.hideHud()
            self.alert("Xoá bài đăng thành công", title: "", handler: { (alert) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }) { (error) in
            self.hideHud()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostViewController" {
           if let vc = segue.destination as? PostViewController {
            vc.mEditPostData = self.productDetail
            vc.mSelectedService = self.productDetail.post.id_service
            }
        }
    }
    
    @IBAction func tappedEditProduct(_ sender: Any) {
//        performSegue(withIdentifier: "PostViewController", sender: Any?.self)
    }
    
    @IBAction func tappedPhoneCall(_ sender: Any) {
        
        let phoneURL = URL(string: "tel:\(productDetail.host.phone)")
        
        if(UIApplication.shared.canOpenURL(phoneURL!)){
            UIApplication.shared.openURL(phoneURL!)
        } else {
            self.alert("Tính năng này chỉ sử dụng được trên iPhone!")
        }
        
        
    }
    
    
    @IBAction func tappedChat(_ sender: Any) {
        // self.alertInDevelopmentFeature()
        
        MBProgressHUD().show(animated: true)
        
        let conversationVC = ConversationViewController(nibName: ConversationViewController.nibName, bundle: nil)
        
        // Pass data
        var conversation = ConversationModel()
        conversation.host = UserModel()
        conversation.host?.id = self.productDetail.host.id
        conversation.host?.avatar = self.productDetail.host.avatar
        conversation.host?.name = self.productDetail.host.name
        conversation.user = UserModel()
        conversation.user?.id = UserManager.user.id()
        conversation.user?.avatar = UserManager.user.avatar()
        conversation.user?.name = UserManager.user.name()
        conversation.idPost = self.post_id
        
        var destinationDS = conversationVC.router.dataStore
        destinationDS?.conversation = conversation
        
        // POST first message
        let requestPostMessage = Conversation.Request.POSTMessage(userId: UserManager.user.id(),
                                                                  hostId: self.productDetail.host.id,
                                                                  postId: self.post_id,
                                                                  time: Date().messageTimeString(),
                                                                  type: "1",
                                                                  content: "Chào Anh/Chị, em muốn hỏi căn hộ nhà mình còn không vậy ạ?",
                                                                  attachId: self.post_id)
        conversationVC.output.requestPOSTMessage(request: requestPostMessage, completion: { [weak self] in
            MBProgressHUD().hide(animated: true)
            self?.navigationController?.pushViewController(conversationVC, animated: true)
        })
    }
    
    @IBAction func tappedLike(_ sender: Any) {
        self.tappedFavorite(sender)
//        
//        if(UserManager.user.type() == 2){
//            return
//        }
//        self.showHud()
//        var userType = 0
//        if productDetail.is_favourite == 1 {
//            userType = 2
//        } else {
//            userType = 1
//        }
//        DispatchQueue.global(qos: .background).async {
//            NetworkManager.shareInstance.apiPostFavorite(idUser: UserManager.user.id(), idPost: self.post_id, userType: userType) { (data, messge, isSuccess) in
//                if isSuccess {
//                    DispatchQueue.global(qos: .background).async {
//                        self.getProductDetail()
//                    }
//                } else {
//                    self.hideHud()
//                }
//            }
//        }
    }
    
    
    @IBAction func tappedFavorite(_ sender: Any) {
        
        self.showHud()
        var userType = 0
        if productDetail.is_favourite == 1 {
            userType = 2
        } else {
            userType = 1
        }
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiPostFavorite(idUser: UserManager.user.id(), idPost: self.post_id, userType: userType) { (data, messge, isSuccess) in
                DispatchQueue.main.async {
                    self.hideHud()
                    self.getProductDetail()
                }
            }
        }
    }
    
    
    @IBAction func tappedViewProductDetail(_ sender: Any) {
        showPopupProductDetail()
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.listUtility.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailViewCell", for: indexPath) as! ProductDetailViewCell
        cell.set(item: listUtility[indexPath.row])
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionUtilityRoomView.bounds.size.width / 2.1, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}
extension ProductDetailsViewController: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        mPageControl.numberOfPages = listImageProductDetail.count
        return listImageProductDetail.count
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
        let imgUrl = listImageProductDetail[index].addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        DispatchQueue.main.async {
            itemView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "nhatro"), options: .refreshCached)
        }
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
}
