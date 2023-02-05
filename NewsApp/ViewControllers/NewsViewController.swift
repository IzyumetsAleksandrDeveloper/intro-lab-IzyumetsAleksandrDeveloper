//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Izyumets Aleksandr on 04.02.2023.
//

import UIKit

final class NewsViewController: UITableViewController {

    private var articles: [Article] = []
    private let newsService: INewsService
    private let networkManager: INetworkManager
    private var currentPage = 1
    private var isLoading = false
    
    init(newsService: INewsService, networkManager: INetworkManager) {
        self.newsService = newsService
        self.networkManager = networkManager
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray4

        setupNavigationBar()
        setupTableView()
        fetchCachedNews { [weak self] in
            self?.fetchNews()
        }
    }
    
    private func setupNavigationBar() {
        title = "Hot News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchNews))
        refreshButton.tintColor = .white
        navigationItem.rightBarButtonItem = refreshButton
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255)
        
        navigationController?.navigationBar.tintColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemGray5]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGray5]
        
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier, for: indexPath) as? NewsListCell
        else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        let viewCounter = newsService.readCounter(for: article)
        // сначала показываем текст
        let model = NewsListCell.Model(title: article.title, viewCounter: viewCounter, image: nil)
        cell.configure(with: model, for: article.url)
        // загружаем картинку
        newsService.fetchImage(for: article) { image in
            DispatchQueue.main.async {
                let model = NewsListCell.Model(title: article.title, viewCounter: viewCounter, image: image)
                cell.configure(with: model, for: article.url, checkID: true)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        // увеличиваем счетчик просмотра
        let viewCounter = newsService.readCounter(for: article)
        newsService.writeCounter(value: viewCounter + 1, for: article)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // переход на экран деталей
        showDetails(article: article)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // подгрузка следующей страницы
        if !isLoading, indexPath.row >= articles.count - 3 {
            isLoading = true
            currentPage += 1
            fetchNewsFromNetwork()
        }
    }
    
    @objc private func fetchNews() {
        // при принудительном обновлении начинаем с первой страницы
        currentPage = 1
        fetchNewsFromNetwork()
    }
    
    private func fetchNewsFromNetwork() {
        newsService.fetchNews(page: currentPage, cachedOnly: false) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    if self.currentPage == 1 {
                        self.articles = articles
                    } else {
                        self.articles += articles
                    }
                    self.tableView.reloadData()
                case .failure(_):
                    break
                }
                
                if self.refreshControl != nil {
                    self.refreshControl?.endRefreshing()
                }
                self.isLoading = false
            }
            
        }
    }
    
    private func fetchCachedNews(completion: @escaping () -> Void) {
        newsService.fetchNews(page: 1, cachedOnly: true) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self.articles = articles
                    self.tableView.reloadData()
                case .failure(_):
                    break
                }
                
                if self.refreshControl != nil {
                    self.refreshControl?.endRefreshing()
                }
                completion()
            }
            
        }
    }
    
    private func showDetails(article: Article) {
        let newsDetailVC = resolver.newsDetailsAssembly.assemble(article: article)
        navigationController?.pushViewController(newsDetailVC, animated: true)
    }
    
    private func setupTableView() {
        tableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.identifier)
        tableView.rowHeight = 100
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(fetchNews), for: .valueChanged)
        self.refreshControl = refreshControl
    }
}

