//
//  UserViewController.swift
//  ThueNha
//
//  Created by Hoang Son on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var viewHeader: UIView!
    @IBOutlet weak private var mAvatar: UIImageView!
    @IBOutlet weak private var mUserName: UILabel!
    @IBOutlet weak private var mAddress: UILabel!
    @IBOutlet weak private var mPhone: UILabel!
    @IBOutlet weak private var mAward: UIImageView!
    @IBOutlet weak private var mWalletLbl: UILabel!
    @IBOutlet weak private var mPostView: UIView!
    
    
    var arrayNew : Array<MDNews> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        mAward.isHidden = true
        mAvatar.layer.masksToBounds = true
        mAvatar.contentMode = .scaleAspectFill
        
        
        let width = self.view.bounds.size.width
        let padding = (width - 150 * 2) / 2
        
        let columnLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: padding/2,
            minimumLineSpacing: padding,
            sectionInset: UIEdgeInsets(top: padding/2, left: padding/2, bottom: padding/2, right: padding/2)
        )
        collectionView?.collectionViewLayout = columnLayout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Cá nhân"
        self.loadData()
        if(UserManager.user.isLogin()) {
            NetworkManager.shareInstance.apiRefreshLoginData { (data, message, isSuccess) in
                self.loadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    func loadData() {
        let url = UserManager.user.avatar()
        
        if (url != "") {
            mAvatar.sd_setImage(with: URL(string:url), placeholderImage: UIImage(named: "thuenha"), options: .highPriority, completed: nil)
        } else {
            mAvatar.image = UIImage(named: "thuenha")
        }
        
        mUserName.text = UserManager.user.name()
        
        mAddress.text = UserManager.user.address()
        mPhone.text = UserManager.user.phone()
        let account = UserManager.user.account()
        if let priceValue = account.toFloat() {
            mWalletLbl.text = formatBalance(digit: priceValue)
        }
        if(UserManager.user.type() == 2) {
            NetworkManager.shareInstance.apiGetListNewsExport(idUser: UserManager.user.id()) { (data, messge, isSuccess) in
                if(isSuccess) {
                    let arr = data as! Array<MDNews>
                    self.arrayNew.removeAll()
                    self.arrayNew.append(contentsOf: arr)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            self.mPostView.isHidden = false
        } else {
            arrayNew.removeAll()
            self.mPostView.isHidden = true
        }
    }
    
    @IBAction func doReCharge(_ sender: Any) {
        self.view.showPopupRecharge()
    }
    
    @IBAction func doLogout(_ sender: Any) {
        let tabbar = self.tabBarController as! RootTabBarController
        tabbar.logout()
        
    }
    
    @objc func gotoSeenList(_ id : String) {
        self.performSegue(withIdentifier: "user_to_list_viewer", sender: id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "user_to_list_viewer") {
            let viewController = segue.destination as? ListViewerViewController
            viewController?.mPostId = sender as? String
        }
    }
    
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayNew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : NewsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.setDataForCell(mdNew: self.arrayNew[indexPath.row
            ], cellType: .userPost, target: self, selector: #selector(gotoSeenList(_:)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.arrayNew[indexPath.row]
        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
        productDetailVC.post_id = data.id!
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 170)
    }
    
}
