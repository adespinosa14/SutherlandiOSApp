//
//  EventsContext.swift
//  iOSApp
//
//  Created by Andrew Espinosa on 11/24/24.
//

import UIKit

protocol EventModelDelegate
{
    func itemsDownloaded(new_events: [Event])
}

class EventsContext: NSObject
{
    
    var delegate:EventModelDelegate?
//MARK: Get Items
    func getItems()
    {
        // Make Url
        let static_url = String("http://127.0.0.1:5000/api/events")
        
        // Create Service URL
        let url = URL(string: static_url)
        
        if let url = url
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if(error != nil)
                {
                    // Error has occured
                    print("Could Not Retrieve Data")
                }
                else
                {
                    // Success
                    self.parseJSON(data)
                }
                
            }
            
            task.resume()
        }
        
    }
    
    
//MARK: Parst JSON Data
    func parseJSON(_ data: Data?)
    {
        var eventArray = [Event]()
        do
        {
            // Create array list for JSON objects
            let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
            
            for jsonResult in jsonArray
            {
                let jsonDict = jsonResult as! [String:String]
                
                let new_events = Event(eventId: jsonDict["id"]!, eventName: jsonDict["Event_Name"]!, eventDescription: jsonDict["Event_Description"]!, eventDate: jsonDict["Event_Date"]!, eventLocation: jsonDict["Event_Location"]!)
                
                // Add to array
                eventArray.append(new_events)
            }
            // Pass Events array back to the delegate
            delegate?.itemsDownloaded(new_events: eventArray)
        }
        catch
        {
            print("Error Occured Parsing to JSON")
        }
    }
    
}
