//
//  ArticleTableViewCell.swift
//  Articles
//
//  Created by Liat Prasa on 18/10/2020.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var articleimage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(article: Article) {
        articleimage.sd_setImage(with: URL(string: article.imageUrl ?? ""), placeholderImage: UIImage.init(named: "save"), completed: { (image, error, cache, url) in
            if error != nil {
            }})
        titleLabel.text = article.title
        writerImage.sd_setImage(with: URL(string: article.auther?.avatar ?? ""))
        writerImage.layer.borderWidth = 1
        writerImage.layer.masksToBounds = false
        writerImage.layer.borderColor = UIColor.clear.cgColor
        writerImage.layer.cornerRadius = writerImage.frame.height/2
        writerImage.clipsToBounds = true
        writerLabel.text = article.auther?.name
        categoryLabel.text = article.category
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: article.createDate ?? "") {
            dateFormatter.dateFormat = "dd MMMM, yyyy"
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = dateString
        }
        
        if let isLiked = article.isLiked, isLiked {
            likeImage.image = UIImage(named: "liked")
            likeCountLabel.text = "\(article.likesCount ?? 0)"
            likeCountLabel.isHidden = false
        }
        else {
            likeImage.image = UIImage(named: "like")
            likeCountLabel.isHidden = true
        }
        saveImage.image = article.isSaved ?? false ?  UIImage(named: "saved"): UIImage(named: "save")
        
    }
}
