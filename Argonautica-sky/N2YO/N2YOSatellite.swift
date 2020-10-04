//
//  N2YOSatellite.swift
//  Argonautica
//
//  Created by Giorgi Butbaia on 10/4/20.
//  Copyright © 2020 Argonautica. All rights reserved.
//

import Foundation
import Alamofire

struct Position {
    public var longitude: Float
    public var latitude: Float
    public var altitude: Float
    public var elevation: Float
    public var azimuth: Float
}

class N2YOSatellite {
    private static let URL = "https://www.n2yo.com/rest/v1"
    private static let API_KEY = "A2DQLP-PHXEC6-GY7Z5E-4KE8"
    
    /**
     * Returns TLE data for a Satellite.
     * @param noradID: NORAD Index of the Satellite
     */
    static func getTLE(_ noradID: UInt, _ completionHandler: @escaping (AFDataResponse<Any>) -> ()) {
        let requestTLEURL = "\(URL)/satellite/tle/\(noradID)"
        let request = AF.request(requestTLEURL, parameters: ["apiKey": API_KEY])
        request.responseJSON {
            json in
            completionHandler(json)
        }
    }

    /**
     * Parses position array.
     * @param position: A position output from the API
     * @return: (longitude, latitude, altitude, elevation, azimuth)
     */
    private static func parsePositions(_ position: [String: Any]) -> (Float, Float, Float, Float, Float) {
        return (
            (position["satlongitude"] as? NSNumber)?.floatValue ?? 0,
            (position["satlatitude"] as? NSNumber)?.floatValue ?? 0,
            (position["sataltitude"] as? NSNumber)?.floatValue ?? 0,
            (position["elevation"] as? NSNumber)?.floatValue ?? 0,
            (position["azimuth"] as? NSNumber)?.floatValue ?? 0)
    }

    /**
     * Returns satellite coordinates
     * @param noradID: NORAD index of the Satellite
     * @param observerLongitude: Longitude of the observer
     * @param observerLatitude: Latitude of the observer
     * @param observerAltitude: Altitude of the observer (above the sea level)
     */
    static func getPosition(
            _ noradID: UInt, _ observerLongitude: Float, _ observerLatitude: Float, _ observerAltitude: Float,
            _ completionHandler: @escaping (Position) -> ()) {
        let requestURL = "\(URL)/satellite/positions/\(noradID)/\(observerLatitude)/\(observerLongitude)/\(observerAltitude)/1"
        let request = AF.request(requestURL, parameters: ["apiKey": API_KEY])
        request.responseJSON {
            response in
            switch (response.result) {
                case .success(let data):
                    if let data = data as? [String: Any] {
                        let positions = data["positions"] as! [[String: Any]]
                        let (longitude, latitude, altitude, elevation, azimuth) = parsePositions(positions[0])

                        completionHandler(
                            Position(
                                longitude: longitude,
                                latitude: latitude,
                                altitude: altitude,
                                elevation: elevation,
                                azimuth: azimuth))
                    }
                case .failure(let error):
                    print("An error has occured: \(error)")
            }
        }
    }
}
