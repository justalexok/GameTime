////
////  HealthKit.swift
////  GameTime Watch App
////
////  Created by Alex Goulder on 06/08/2024.
////
//
//import HealthKit
//
//class HealthKitManager {
//    let healthStore = HKHealthStore()
//    
//    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
//        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
//        
//        let healthKitTypes: Set = [heartRateType]
//        
//        healthStore.requestAuthorization(toShare: nil, read: healthKitTypes) { success, error in
//            completion(success, error)
//        }
//    }
//    
//    func startHeartRateQuery(completion: @escaping (Double) -> Void) {
//        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
//        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, error in
//            if error != nil {
//                return
//            }
//            self.fetchLatestHeartRateSample { sample in
//                if let sample = sample {
//                    let heartRateUnit = HKUnit(from: "count/min")
//                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
//                    completion(heartRate)
//                }
//                completionHandler()
//            }
//        }
//        healthStore.execute(query)
//    }
//    
//    private func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
//        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
//        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
//        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, _ in
//            completion(results?.first as? HKQuantitySample)
//        }
//        healthStore.execute(query)
//    }
//}
