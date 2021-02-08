//
//  MusicViewModel.swift
//  Music
//
//  Created by Ankit Bansal on 08/02/21.
//

import Foundation

class MusicViewModel {
    
    func apiToFetchTracks(completion: @escaping (Music?, String?) -> ()){
        
        var request = URLRequest(url: URL(string: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=25/json")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                            if let response = self.parseJSON(response: json) {
                                completion(response, nil)
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                        completion(nil, error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: Convert JSON To Model
    
    private func convertJsonObjectToModel<T: Decodable>(_ object: [String: Any], modelType: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            
            let reqJSONStr = String(data: jsonData, encoding: .utf8)
            let data = reqJSONStr?.data(using: .utf8)
            let jsonDecoder = JSONDecoder()
            do {
                let modelObj = try jsonDecoder.decode(modelType, from: data!)
                return modelObj
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
        return nil
    }
    
    
    // MARK: Parse Response
    
    func parseJSON(response: [String: Any]) -> Music? {
        if let welcome = convertJsonObjectToModel(response, modelType: Music.self) {
            return welcome
        }
        return nil
    }
    
}
