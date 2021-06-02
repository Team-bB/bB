//
//  UpdateDeviceTokenAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/06/02.
//

import Foundation

import Alamofire

class UpdateDeviceTokenAPI {
    
    static let shared = UpdateDeviceTokenAPI()

    private init() {}
    
    func put(completion: @escaping (Result<UpdateDeviceTokenAPIResponse, Error>) -> (Void)) {
        let url = API.shared.BASE_URL + "/members"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        guard let accountId = UserDefaults.standard.string(forKey: "accountId"),
              let deviceToken = UserDefaults.standard.string(forKey: "device_token") else { return }
        
        let params = ["account_id" : accountId,
                      "device_token" : deviceToken] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\n메일 인증 POST 성공")
      
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(UpdateDeviceTokenAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ Token Update Success ✅")
                    completion(.success(product))
                
                } catch {
                    debugPrint(response)
                    print("❗️ Token Update Error")
                    print(error)
                    completion(.failure(error))
                }
                
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                completion(.failure(error))
            }
        }
    }
}
