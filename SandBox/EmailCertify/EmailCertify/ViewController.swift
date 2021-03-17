//
//  ViewController.swift
//  EmailCertify
//
//  Created by 홍화형 on 2021/03/11.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    // MARK: IBOutlet 및 변수 ---------------------
    let colleges = ["불교대학",
                    "문과대학",
                    "이과대학",
                    "법과대학",
                    "사회과학대학",
                    "경찰사법대학",
                    "경영대학",
                    "바이오시스템대학",
                    "공과대학",
                    "사범대학",
                    "예술대학",
                    "약학대학",
                    "미래융합대학"]
    let majors = [["불교학부"], //불교대학
                  ["국어국문문예창작학부","영어문학전공","영어통번역학전공","일본학과","중어중문학과","철학과","사학과","윤리문화학전공"], //문과대학
                  ["수학과","화학과","통계학과","물리반도체과학부"], //이과대학
                  ["법학과"], //법과대학
                  ["정치외교학전공","행정학전공","북한학전공","경제학과","국제통상학과","사회학전공","미디어커뮤니케이션전공","식품산업관리학과","광고홍보학과","사회복지학과"],//사회과학대학
                  ["경찰행정학부"], //경찰사법대학
                  ["경영학과","회계학과","경영정보학과"], //경영대학
                  ["바이오환경과학과","생명과학과","식품생명공학과","의생명공학과"], //바이오시스템대학
                  ["건설환경공학과","건축학전공","건축공학전공","기계로봇에너지공학과","멀티미디어공학과","산업시스템공학과","융합에너지신소재공학과","전자전기공학부","정보통신공학전공","컴퓨터공학전공","화공생물공학과"], //공과대학
                  ["교육학과","국어교육과","역사교육과","지리교육과","수학교육과","가정교육과","체육교육과"], //사범대학
                  ["미술학부","연극학부","영상영화학과","스포츠문화학과"], //예술대학
                  ["약학과"], //약학대학
                  ["융합보안학과","사회복지상담학과","글로벌무역학과"]] //미래융합대학
    let mbtis = ["ENFJ",
                 "ENFP",
                 "ENTJ",
                 "ENTP",
                 "ESFJ",
                 "ESFP",
                 "ESTJ",
                 "ESTP",
                 "INFJ",
                 "INFP",
                 "INTJ",
                 "INTP",
                 "ISFJ",
                 "ISFP",
                 "ISTJ",
                 "ISTP"]
    
    var collegePickerView = UIPickerView()
    var majorPickerView = UIPickerView()
    var mbtiPikcerView = UIPickerView()
    
    let grayColor = #colorLiteral(red: 0.7036006266, green: 0.7036006266, blue: 0.7036006266, alpha: 1)
    let orangeColor = #colorLiteral(red: 1, green: 0.6597687742, blue: 0.3187801202, alpha: 1)
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var okayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: textFields)
        
        okayButton.isEnabled = false
        okayButton.layer.cornerRadius = 10
        okayButton.backgroundColor = grayColor
        
        textFields[0].inputView = collegePickerView
        textFields[1].inputView = majorPickerView
        textFields[4].inputView = mbtiPikcerView
        
        collegePickerView.delegate = self
        collegePickerView.dataSource = self
        majorPickerView.delegate = self
        majorPickerView.dataSource = self
        mbtiPikcerView.delegate = self
        mbtiPikcerView.dataSource = self
        
        collegePickerView.tag = 1
        majorPickerView.tag = 2
        mbtiPikcerView.tag = 3
        
        createToolBar()
    }
    
    // MARK: Alamofire --------------------
    private func postText() {
        let url = API.shared.BASE_URL + "/auth"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        //POST로 보낼 정보
        let params = ["college": textFields[0].text,
                      "major": textFields[1].text,
                      "age": textFields[2].text,
                      "height": textFields[3].text,
                      "mbti": textFields[4].text,
                      "email": textFields[5].text] as Dictionary
        
        // httpBody에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                debugPrint(response)
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    //MARK: ToolBar --------------------
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(buttonAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace,doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        textFields[0].inputAccessoryView = toolBar
        textFields[1].inputAccessoryView = toolBar
        textFields[4].inputAccessoryView = toolBar
        }
    @objc func buttonAction() {
        textFields[0].resignFirstResponder()
        textFields[1].resignFirstResponder()
        textFields[4].resignFirstResponder()
    }
    
    @IBAction func okayBtnTapped(_ sender: UIButton) {
        var count = 0
        for i in textFields {
            if i.text == "" {
                count += 1
            }
        }
        if count == 0 {
            okayButton.isEnabled = true
            okayButton.backgroundColor = orangeColor
        } else {
            okayButton.isEnabled = false
            okayButton.backgroundColor = grayColor
        }
    }
    
}

// MARK: TetxField -----------------------
extension ViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc private func textDidChange(_ notification: Notification) {
        var count = 0
        if let textFields = notification.object as? [UITextField] {
            for textField in textFields {
                if textField.text == "" {
                    count += 1
                }
            }
            if count == 0 {
                okayButton.isEnabled = true
                okayButton.backgroundColor = orangeColor
            } else {
                okayButton.isEnabled = false
                okayButton.backgroundColor = grayColor
            }
        }
    }
    func allTextFilled(_ textFields: [UITextField]) {
        var count = 0
        for i in textFields {
            if i.text == "" {
                count += 1
            }
        }
        if count == 0 {
            okayButton.isEnabled = true
            okayButton.backgroundColor = orangeColor
        } else {
            okayButton.isEnabled = false
            okayButton.backgroundColor = grayColor
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return colleges.count
        case 2:
            if textFields[0].text == "불교대학" {
                return majors[0].count
            } else if textFields[0].text == "문과대학" {
                return majors[1].count
            } else if textFields[0].text == "이과대학" {
                return majors[2].count
            } else if textFields[0].text == "법과대학" {
                return majors[3].count
            } else if textFields[0].text == "사회과학대학" {
                return majors[4].count
            } else if textFields[0].text == "경찰사법대학" {
                return majors[5].count
            } else if textFields[0].text == "경영대학" {
                return majors[6].count
            } else if textFields[0].text == "바이오시스템대학" {
                return majors[7].count
            } else if textFields[0].text == "공과대학" {
                return majors[8].count
            } else if textFields[0].text == "사범대학" {
                return majors[9].count
            } else if textFields[0].text == "예술대학" {
                return majors[10].count
            } else if textFields[0].text == "약학대학" {
                return majors[11].count
            } else {
                return majors[12].count
            }
        case 3:
            return mbtis.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return colleges[row]
        case 2:
            if textFields[0].text == "불교대학" {
                return majors[0][row]
            } else if textFields[0].text == "문과대학" {
                return majors[1][row]
            } else if textFields[0].text == "이과대학" {
                return majors[2][row]
            } else if textFields[0].text == "법과대학" {
                return majors[3][row]
            } else if textFields[0].text == "사회과학대학" {
                return majors[4][row]
            } else if textFields[0].text == "경찰사법대학" {
                return majors[5][row]
            } else if textFields[0].text == "경영대학" {
                return majors[6][row]
            } else if textFields[0].text == "바이오시스템대학" {
                return majors[7][row]
            } else if textFields[0].text == "공과대학" {
                return majors[8][row]
            } else if textFields[0].text == "사범대학" {
                return majors[9][row]
            } else if textFields[0].text == "예술대학" {
                return majors[10][row]
            } else if textFields[0].text == "약학대학" {
                return majors[11][row]
            } else {
                return majors[12][row]
            }
        case 3:
            return mbtis[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            textFields[0].text = colleges[row]
            textFields[1].text = ""
        case 2:
            if textFields[0].text == "불교대학" {
                textFields[1].text = majors[0][row]
            } else if textFields[0].text == "문과대학" {
                textFields[1].text = majors[1][row]
            } else if textFields[0].text == "이과대학" {
                textFields[1].text = majors[2][row]
            } else if textFields[0].text == "법과대학" {
                textFields[1].text = majors[3][row]
            } else if textFields[0].text == "사회과학대학" {
                textFields[1].text = majors[4][row]
            } else if textFields[0].text == "경찰사법대학" {
                textFields[1].text = majors[5][row]
            } else if textFields[0].text == "경영대학" {
                textFields[1].text = majors[6][row]
            } else if textFields[0].text == "바이오시스템대학" {
                textFields[1].text = majors[7][row]
            } else if textFields[0].text == "공과대학" {
                textFields[1].text = majors[8][row]
            } else if textFields[0].text == "사범대학" {
                textFields[1].text = majors[9][row]
            } else if textFields[0].text == "예술대학" {
                textFields[1].text = majors[10][row]
            } else if textFields[0].text == "약학대학" {
                textFields[1].text = majors[11][row]
            } else {
                textFields[1].text = majors[12][row]
            }
        case 3:
            textFields[4].text = mbtis[row]
        default:
            return
        }
    }
}
