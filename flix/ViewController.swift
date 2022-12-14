//
//  ViewController.swift
//  flix
//
//  Created by Atinuke Ayangade on 9/23/22.
//

import UIKit
import AlamofireImage

//how to create table view
//STEP 1: add UITableViewDataSource and UITableViewDelegate
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //STEP 2: implement these two functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        //gives recycled cell
    
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        
        cell.posterView.af.setImage(withURL: posterUrl)
        
        return cell
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()
    //collection of an array of dictionaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //STEP 3: call two functions from STEP 2
        tableView.dataSource = self
        tableView.delegate = self
        
        
       
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 self.movies = dataDictionary["results"] as! [[String:Any]]
                 self.tableView.reloadData() //calls functions from STEP 2 again
                 //print(dataDictionary)

                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1. find the selected movie
        let cell = sender as! UITableViewCell //sender is the table view cell
        
        let indexPath = tableView.indexPath(for: cell)! //table view knows for a given cell, what the indexPath is
        let movie = movies[indexPath.row]
        
        //2. pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        tableView.deselectRow(at: indexPath, animated: true) //unhighlights selected row, finishing touches
        
       
    }
    
    


}

