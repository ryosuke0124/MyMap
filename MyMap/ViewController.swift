//
//  ViewController.swift
//  MyMap
//
//  Created by 片野良祐 on 2019/11/11.
//  Copyright © 2019 Ryosuke_katano. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボードを閉じる（１）
        textField.resignFirstResponder()
        
        // 入力された文字を取り出す（２）
        if let searchKey = textField.text {
            
            // 入力された文字をデバックエリアに表示（３）
            print(searchKey)
            
            // CLGeocoderインスタンスを取得（５）
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得（６）
            geocoder.geocodeAddressString(searchKey , completionHandler: { (placemarks, error) in
                
                // 位置情報が存在する場合は、unwrapPlacemarksに取り出す（７）
                if let unwrapPlacemarks = placemarks {
                    
                    // １件目の情報を取り出す（８）
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        // 位置情報を取り出す（９）
                        if let location = firstPlacemark.location{
                            
                            // 位置情報から緯度経度をtargetCoordinateに取り出す（１０）
                            let targetCoordinate = location.coordinate
                            
                            // 緯度経度をデバックエリアに表示（１１）
                            print(targetCoordinate)
                            
                            // MkPointAnnotationインスタンスを取得し、ピンを生成（１２）
                            let pin = MKPointAnnotation()
                            
                            // ピンの置く場所に緯度経度を設定（１３）
                            pin.coordinate = targetCoordinate
                            
                            // ピンのタイトルを設定（１４）
                            pin.title = searchKey
                            
                            // ピンを地図に置く（１５）
                            self.dispMap.addAnnotation(pin)
                            
                            // 緯度経度を中心にして半径500mの範囲を表示（１６）
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }
            })
        }
        
        // デフォルト動作を行うのでtrueを返す（４）
        return true
    }

    @IBAction func changeMapButton(_ sender: Any) {
        // mapTypeプロパティー値をトグル
        // 標準 → 航空写真 → 航空写真＋標準
        // → 3D Flyover → 3D Flyover＋標準
        // → 交通機関
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else if dispMap.mapType == .hybridFlyover {
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
    }
}
