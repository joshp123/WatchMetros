//
//  ComplicationController.swift
//  WatchMetros WatchKit Extension
//
//  Created by Josh Palmer on 28/09/2019.
//  Copyright © 2019 Josh Palmer. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let url = URL(string: "http://localhost:5000/morning")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
        
        switch(complication.family) {
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTable()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Metros from Blijdorp")
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "S")
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "5, 10, 15, every 5m")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "N")
            template.row2Column2TextProvider = CLKSimpleTextProvider(text:
                "5, 10, 15, every 15m")
            // Create the timeline entry.
           let entry = CLKComplicationTimelineEntry(date: Date(),
                                                    complicationTemplate: template)
           
           // Pass the timeline entry to the handler.
           handler(entry)

        default:
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        switch(complication.family) {
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTable()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Metros from Fake")
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "S")
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "5, 10, 15, every 5m")
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "N")
            template.row2Column2TextProvider = CLKSimpleTextProvider(text:
                "5, 10, 15, every 15m")
           
           // Pass the timeline entry to the handler.
           handler(template)

        default:
            handler(nil)
        }

    }
    
}
