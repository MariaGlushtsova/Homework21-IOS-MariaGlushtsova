//
//  ViewController.swift
//  Test
//
//  Created by Admin on 10.09.23.
//

import UIKit
import Alamofire
import CryptoKit

class ViewController: UIViewController {
    
    struct HTTPBinResponse: Decodable { let url: String }
    
    var data: [JessicaJonesSeries] = []
    
    private var mainView: MainView {
        return view as! MainView
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        fetchSeries()
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Jessica Jones Series"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(mainView.tableView)
    }
    
//    private func registerCell() {
//
//        mainView.tableView.register(SeriesTableViewCell.self, forCellReuseIdentifier: "Se")
//    }
//
    private func fetchSeries() {
        //        let apiKey = "bdd48a56f3f454e6bdfcd5fde74865d8"
        //        let privateKey = "92af51b58d8579e8ae6f6c242b23704d43ad2fc6"
        //        let baseURL = "https://gateway.marvel.com/v1/publichttps://gateway.marvel.com/v1/public/characters/1009378/series"
        //
        //        let timestamp = String(Date().timeIntervalSince1970)
        //        let hash = MD5(string: timestamp + privateKey + apiKey).map { String(format: "%02hhx", $0) }.joined()
        //
        //        let parameters: [String: Any] = [
        //            "apikey": apiKey,
        //            "ts": timestamp,
        //            "hash": hash
        //        ]
//        AF.request("https://gateway.marvel.com/v1/public/characters/1009378/series?ts=1&apikey=17f5b878ef1fe2f49a005a90a9967aa9&hash=fa3a74f0e4fcd5aecc20f1516bc66ed4").responseDecodable(of: Series.self) { (response) in
//            debugPrint(response)
//            switch response.result {
//            case .success:
//                self.data = response.value?.series ?? []
//
//
//            break
//        case .failure:
//            break
//        }
//}
        
        AF.request("https://gateway.marvel.com/v1/public/characters/1009378/series?ts=1&apikey=17f5b878ef1fe2f49a005a90a9967aa9&hash=fa3a74f0e4fcd5aecc20f1516bc66ed4").responseJSON { [weak self] response in
            guard let self = self else { return }
debugPrint(response)
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                    let data = json["data"] as? [String: Any],
                let  results = data["results"] as? [[String: Any]] {

                    for result in results {
                        if let title = result["title"] as? String,
                           let description = result["description"] as? String,
                           let thumbnail = result["thumbnail"] as? [String: Any],
                           let thumbnailURLString = thumbnail["path"] as? String,
                           let thumbnailExtension = thumbnail["extension"] as? String {

                            let thumbnailURLString = thumbnailURLString + "." + thumbnailExtension
                            let thumbnailURL = URL(string: thumbnailURLString)
                            print("Thumbnail URL: \(thumbnailURLString)")

                            let series = JessicaJonesSeries(title: title, description: description, coverImageURL: thumbnailURL)
                            self.data.append(series)
                        }
                    }
                    self.mainView.tableView.reloadData()
                }

            case .failure(let error):
                print("Ошибка при выполнении запроса: \(error)")
            }
        }
    }
    
    private func MD5(string: String) -> Data {
        let data = Data(string.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return Data(hash)
    }
}
    

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesTableViewCell", for: indexPath) as? SeriesTableViewCell
        let model = data[indexPath.row]
        cell?.configure(with: model)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = data[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let detailInformationViewController = DetailInformationViewController(DetailInformationViewController.InitData())
        present(detailInformationViewController, animated: true)
    }
}
