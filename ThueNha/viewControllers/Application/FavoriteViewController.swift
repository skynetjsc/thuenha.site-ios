//
//  FavoriteViewController.swift
//  ThueNha
//
//  Created by Hoang Son on 12/6/18.
//  Copyright © 2018 Skynet Software. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {
    var arrayNew : Array<MDNews> = []
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.collectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        } else {
            self.collectionView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
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
        if(UserManager.user.type() == 1) {
            self.navigationItem.title = "Yêu thích"
        } else {
            self.navigationItem.title = "Tin đăng của tôi"
        }
        self.updateData()
    }
    
    @objc private func updateData() {
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
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.hideHud()
                }
            }
        } else {
            NetworkManager.shareInstance.apiGetListFavourite(idUser: UserManager.user.id()) { (data, messge, isSuccess) in
                if isSuccess {
                    self.arrayNew = data as! Array<MDNews>
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.hideHud()
                }
            }
        }
        
        
    }
    
    @objc func unFavorite(_ id : String) {
        self.showHud()
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shareInstance.apiPostFavorite(idUser: UserManager.user.id(), idPost: id, userType: 2) { (data, messge, isSuccess) in
                DispatchQueue.global(qos: .background).async {
                    self.updateData()
                }
            }
        }
        
    }
    
    @objc func gotoSeenList(_ id : String) {
        self.performSegue(withIdentifier: "favorite_to_list_viewer", sender: id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "favorite_to_list_viewer") {
            let viewController = segue.destination as? ListViewerViewController
            viewController?.mPostId = sender as? String
        }
    }
    
    
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayNew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:NewsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        if(UserManager.user.type() == 1) {
            cell.setDataForCell(mdNew: self.arrayNew[indexPath.row
            ], cellType:.favourite, target: self, selector:#selector(self.unFavorite(_:)))
        } else {
            cell.setDataForCell(mdNew: self.arrayNew[indexPath.row
                ], cellType: .userPost, target: self, selector: #selector(gotoSeenList(_:)))
        }
        
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
