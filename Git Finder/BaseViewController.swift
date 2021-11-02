//
//  BaseViewController.swift
//  Git Finder
//
//  Created by Asif Mimi Rabbi on 2/11/21.
//

import UIKit
import SDWebImage

class BaseViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gitFinderTableView: UITableView!
    
    var movies = [Results]()
    var searchedMovies = [Results]()
    
    var movieName = [""]
    
    var searched = [String]()
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gitFinderTableView.rowHeight = UITableView.automaticDimension
        gitFinderTableView.estimatedRowHeight = UITableView.automaticDimension
        request()
        searchBar.delegate = self
        gitFinderTableView.keyboardDismissMode = .onDrag
    }
    
    func request(_ movie : String = "marvel") {
        let session = URLSession.shared
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=38e61227f85671163c275f9bd95a8803&query=\(movie)")
        else { return }
        
        let task = session.dataTask(with: url) { [self] data, response, error in
            
            if error != nil || data == nil {
                print("=========Client error!=========")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("=========Server error!=========")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("=========Wrong MIME type!=========")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let data = try decoder.decode(Movie.self, from: data!)
                self.movies = data.results
                self.searchedMovies = data.results
                movieName.append(searchedMovies[0].originalTitle ?? "Not found")
            } catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.gitFinderTableView.reloadData()
            }
        }
        task.resume()
    }
}

extension BaseViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedMovies.count
        } else {
            return movies.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCellTVC") as! RepoCellTVC
        
        
        func cells() {
            let data = movies[indexPath.row]
            cell.nameLbl.text = data.originalTitle
            cell.desciptionTxtView.text = data.overview
            
            cell.adjustTextViewHeight(textview: cell.desciptionTxtView)
            
            let noImage = "https://png.pngtree.com/png-clipart/20190921/original/pngtree-no-photo-taking-photo-illustration-png-image_4698291.jpg"
            let cdn = "https://image.tmdb.org/t/p/w500/"
            let url =  data.backdropPath
            if url != nil{
                cell.profileImg.sd_setImage(with: URL(string: cdn + url!))
            }else{
                cell.profileImg.sd_setImage(with: URL(string: noImage))
            }
        }
        
        if searching {
            cells()
        } else {
            cells()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gitFinderTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension BaseViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        request(searchText)
        searched =  movieName.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searching = false
        searchBar.text = ""
        request()
        self.gitFinderTableView.reloadData()
    }
}
