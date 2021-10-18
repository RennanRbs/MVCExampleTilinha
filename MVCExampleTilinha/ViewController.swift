//
//  CharsViewController.swift
//  MVCExampleTilinha
//
//  Created by Lucas Tavares on 18/10/21.
//

import UIKit

struct AgentResponse: Codable {
    let status: Int
    let data: [Agent]
}

struct Agent: Codable {
    let displayName: String
}

class CharsViewController: UIViewController {
    
    private var model: [Agent]?

    lazy var charsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchAgents()
    }
    
    func fetchAgents() {
        URLSession.shared.dataTask(with: URL(string: "https://valorant-api.com/v1/agents")!) { responseData, responseUrl, error in
            guard let responseData = responseData else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(AgentResponse.self, from: responseData)
                    self.model = response.data
                    self.charsTableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func setupLayout() {
        view.addSubview(charsTableView)
        NSLayoutConstraint.activate([
            charsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            charsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            charsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = model![indexPath.row].displayName
        return cell
    }
}
