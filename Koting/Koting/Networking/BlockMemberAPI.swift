//
//  BlockMemberAPI.swift
//  Koting
//
//  Created by 임정우 on 2021/06/13.
//

import Foundation
import Alamofire

class BlockMemberAPI {
    
    static let shared = BlockMemberAPI()
    
    private init() {}
    
    func post(accountId: String, otherId: String, content: String, completion: @escaping (Result<BlockMemberAPIResponse, Error>) -> (Void)) {
        
        let url = API.shared.BASE_URL + "/"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        let params = [
            "my_account_id" : accountId,
            "your_account_id" : otherId] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseData { response in
            switch response.result {
            case .success(let result):
                print("\n\n신고POST 성공")
      
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(BlockMemberAPIResponse.self, from: result)
                    debugPrint(response)
                    print("✅ BlockMember Codable Success ✅")
                    completion(.success(product))
                
                } catch {
                    debugPrint(response)
                    print("❗️ BlockMember Codable Error")
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
