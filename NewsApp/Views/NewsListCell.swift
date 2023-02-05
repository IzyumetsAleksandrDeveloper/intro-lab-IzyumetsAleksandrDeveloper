//
//  NewsListCell.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import UIKit

final class NewsListCell: UITableViewCell {
    
    static let identifier = "NewsListCell"
    private var id: String = ""
    
    struct Model {
        let title: String
        let viewCounter: Int
        let image: UIImage?
    }
    
    func configure(with model: Model, for id: String, checkID: Bool = false) {
        if checkID, self.id != id { return }
        self.id = id

        newsImageView.image = model.image
        titleLabel.text = model.title
        subtitleLabel.text = "Количество просмотров - \(model.viewCounter)"
    }
    
    weak var newsImageView: UIImageView!
    weak var titleLabel: UILabel!
    weak var subtitleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        let newsImageView = UIImageView(frame: .zero)
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(newsImageView)
        self.newsImageView = newsImageView
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(subtitleLabel)
        self.subtitleLabel = subtitleLabel
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            newsImageView.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.subtitleLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsImageView.image = nil
        id = ""
    }
}
