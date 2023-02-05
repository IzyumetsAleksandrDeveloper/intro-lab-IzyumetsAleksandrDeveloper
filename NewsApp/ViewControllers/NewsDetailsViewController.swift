//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import UIKit
import WebKit

final class NewsDetailsViewController: UIViewController, WKUIDelegate {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.numberOfLines = 0
        return view
    }()
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.numberOfLines = 0
        return view
    }()
    private let dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10)
        return view
    }()
    private let sourceLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10)
        return view
    }()
    private let linkLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.numberOfLines = 0
        view.textColor = .systemBlue
        return view
    }()
    
    private let newsService: INewsService
    private let article: Article
    
    init(newsService: INewsService, article: Article) {
        self.newsService = newsService
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupSubviews(
            titleLabel,
            imageView,
            descriptionLabel,
            dateLabel,
            sourceLabel,
            linkLabel
        )
        
        setupConstraints()
        loadData()
        setupLinkLabel()
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            sourceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            sourceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            linkLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 20),
            linkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupLinkLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tap)
    }
     
    @objc private func linkTapped() {
        guard let link = linkLabel.text else { return }
        let viewController = NewsLinkViewController(link: link)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func loadData() {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        dateLabel.text = article.publishedAt
        sourceLabel.text = article.source.name
        linkLabel.text = article.url
        
        newsService.fetchImage(for: article) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
