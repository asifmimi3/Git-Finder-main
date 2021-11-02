//
//  RepoCellTVC.swift
//  Git Finder
//
//  Created by Asif Mimi Rabbi on 2/11/21.
//

import UIKit

class RepoCellTVC: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var desciptionTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func adjustTextViewHeight(textview : UITextView) {
        textview.clipsToBounds = false
        textview.translatesAutoresizingMaskIntoConstraints = true
        textview.sizeToFit()
        textview.adjustsFontForContentSizeCategory = true
        textview.isScrollEnabled = false
    }
    
}
