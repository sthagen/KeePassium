//
//  PremiumVC.swift
//  KeePassium
//
//  Created by Andrei Popleteev on 2019-05-17.
//  Copyright © 2019 Andrei Popleteev. All rights reserved.
//

import UIKit
import KeePassiumLib

protocol PremiumDelegate: class {
    func didPressCancel(in premiumController: PremiumVC)
    func didPressRestorePurchases(in premiumController: PremiumVC)
    func didPressBuyForever(in premiumController: PremiumVC)
}

class PremiumVC: UIViewController {

    weak var delegate: PremiumDelegate?
    private var premiumManager: PremiumManager!
    
    @IBOutlet weak var promoPanel: UIView!
    @IBOutlet weak var contentView: UIView!
    
    public static func create(
        premiumManager: PremiumManager,
        delegate: PremiumDelegate? = nil
        ) -> PremiumVC
    {
        let vc = PremiumVC.instantiateFromStoryboard()
        vc.premiumManager = premiumManager
        vc.delegate = delegate
        return vc
    }
    
    // MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // make background image
        contentView.backgroundColor = UIColor(patternImage: UIImage(asset: .backgroundPattern))
        contentView.layer.isOpaque = false
        
        //TODO: load prices
    }
    
    override func viewWillAppear(_ animated: Bool) {
        promoPanel.isHidden = !premiumManager.isLaunchGracePeriod
        
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func didPressCancel(_ sender: Any) {
        delegate?.didPressCancel(in: self)
    }
    
    @IBAction func didPressBuyForever(_ sender: Any) {
        delegate?.didPressBuyForever(in: self)
    }
    
    @IBAction func didPressRestorePurchases(_ sender: Any) {
        delegate?.didPressRestorePurchases(in: self)
    }
}