//
//  ImagesRequest.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 05/10/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import Foundation

struct ImagesRequest {
    let baseURL = "https://api.unsplash.com/search/photos"
    let apiKey = "dcdad029abf714214d392c5833737585362417d225d78b517c9f393db3309a49"
    let imagesPerPage = 30
    
    func getImages(with searchQuery: String, for page: Int = 1, completion: @escaping((Result<[InternetImage], ImagesError>) -> Void)) {
        let url = buildAnUrl(with: searchQuery, for: page)
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let imagesResponse = try decoder.decode(ImagesResponse.self, from: jsonData)
                let internetImages = imagesResponse.results
                completion(.success(internetImages))
            } catch (let error) {
                print(error)
                completion(.failure(.canNotParseData))
            }
        }
        dataTask.resume()
    }
    
    private func buildAnUrl(with searchQuery: String, for page: Int) -> URL {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: apiKey),
            URLQueryItem(name: "query", value: searchQuery),
            URLQueryItem(name: "orientation", value: "portrait"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(imagesPerPage)")
        ]
        return urlComponents.url!
    }
}

enum ImagesError: Error {
    case noDataAvailable
    case canNotParseData
}
