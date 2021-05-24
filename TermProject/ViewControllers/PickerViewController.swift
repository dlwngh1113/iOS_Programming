//
//  ViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/04/27.
//

import UIKit
import Speech

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    private let audioEngine = AVAudioEngine()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    
    var pickerDataSource = ["수원시", "용인시", "성남시", "부천시", "화성시", "안산시", "안양시", "평택시", "시흥시", "김포시",
    "광주시", "광명시", "군포시", "하남시", "오산시", "이천시", "안성시", "의왕시", "양평군", "여주시", "과천시", "고양시", "남양주시", "파주시", "의정부시", "양주시", "구리시", "포천시", "동두천시", "가평군", "연천군"]
    //var url : String = "http://apis.data.go.kr/B551182/hospInfoService/getHospBasisList?pageNo=1&numOfRows=10&serviceKey=sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D&sidoCd=110000&sgguCd="
    //var sgguCd: String = "110023"

    //지은 인증키: KEY=2d29e4b557924fc2b87524d5cda7e8e1
    //주호 날씨 인증키: %2BhwV8qFUEuPQ4dUWbntMWjJi8Lcj5FEdExdT0MZcwPj53cQwNSnBvCeTAerZbJ8NCzNzmHxZrUZXtZzBZ72aag%3D%3D
    var Leisureurl : String = "https://openapi.gg.go.kr/LSST?KEY=2d29e4b557924fc2b87524d5cda7e8e1&Type=xml&pIndex=1&pSize=400"
    var Areaurl: String =
        "https://openapi.gg.go.kr/ADST?KEY=2d29e4b557924fc2b87524d5cda7e8e1&Type=xml&pIndex=1&pSize=400"
    var Weatherurl: String = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?%2BhwV8qFUEuPQ4dUWbntMWjJi8Lcj5FEdExdT0MZcwPj53cQwNSnBvCeTAerZbJ8NCzNzmHxZrUZXtZzBZ72aag%3D%3D&numOfRows=3&pageNo=1&dataType=XML&base_time=0500"
    
    var sgguCd : String = "수원시"
    
    @IBAction func startTranscribing(_ sender: Any) {
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        try! startSession()
    }
    
    func startSession() throws {
        if let recognitionTask = speechRecognitionTask{
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else{
            fatalError("SFSpeechAudioBufferRecognitionRequest Object creattion failed")
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) {
            result, error in
            var finished = false
            
            if let result = result{
                self.myTextView.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                self.transcribeButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer,
                                                                                     when: AVAudioTime) in self.speechRecognitionRequest?.append(buffer)}
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    @IBAction func stopTranscribing(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
        }
        
        for i in 0..<pickerDataSource.count
        {
            if(self.myTextView.text == pickerDataSource[i])
            {
                self.pickerView.selectRow(i, inComponent: 0, animated: true)
                break
            }
        }
        
        //지역명
        sgguCd = self.myTextView.text
    }
    
    @IBAction func doneToPickerViewContorller(segue: UIStoryboardSegue)
    {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToTapBar"
        {
            if let tabBarController = segue.destination as? GlawTapBarController
            {
                tabBarController.leisureURL = Leisureurl
                tabBarController.areaURL = Areaurl
                tabBarController.weatherUIL = Weatherurl
                tabBarController.sgguCd = sgguCd
            }
        }
    }
    
    func authorizeSR()  {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true
                case .denied:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                @unknown default:
                    break
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        authorizeSR()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    func pickerView(_ pickerView:UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component:Int)  {
        
        //지역명 저장
        sgguCd = pickerDataSource[row]
    }
}

