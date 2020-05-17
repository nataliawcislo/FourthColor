//
//  RemeberItemsListView.swift
//  fourColor
//
//  Created by Natalia Wcisło on 04/05/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//


import SwiftUI
import CoreData

struct SavedGridView: View {
    //let lista = ["", "", "", ""]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView{
            HStack{
                VStack{
                    Button(action: {
                        // Navigate to the previous screen
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    })
                }.offset(x:20)
                Spacer()
                ZStack{
                    Text("Gallery")
                        .fontWeight(.light).font(.custom("Helvetica Neue", size: 40)).padding(.top, 10.0)
                }.offset(x:-150)
            }
            VStack{
                GridView()
            }.padding(.horizontal, 10.0)
            
        }
    }
}


struct SavedGridView_Previews: PreviewProvider {
    static var previews: some View {
        SavedGridView()
    }
}




struct GridView: View {
    func fetchPhotos() -> [Photo] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            let req = NSFetchRequest<Photo>(entityName: "Photo")
            let photos = try managedContext.fetch(req)
            return photos
        } catch {
            return []
        }
    }
    
    let col = 2
    var body: some View {
        var grid: [[Int]] = []
        let photos: [Photo] = fetchPhotos()
        print(photos)
        _ = (0..<photos.count).publisher
            .collect(col)
            .collect()
            .sink(receiveValue: { grid = $0 })
        return ForEach(0..<grid.count, id: \.self) { collect in
            HStack {
                ForEach(grid[collect], id: \.self) { number in
                    ZStack {
                        Image(uiImage: UIImage(data: photos[number].image!)!).resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(30)
                        NavigationLink(destination: SavedItemView(photo: photos[number])) {
                            Rectangle().hidden()
                        }
                    }
                }
            }
        }
    }
}

//let listImage: [SavedPhoto] = [
//    SavedPhoto(color: "Donut_Animal", image: 1),
//    SavedPhoto(color: "Donut_Blue",  image: 2),
//    SavedPhoto(color: "Donut_BluePink",  image: 3),
//    SavedPhoto(color: "Donut_Cat",  image: 4),
//    SavedPhoto(color: "Donut_Christmas",  image: 5),
//    SavedPhoto(color: "Donut_Color",  image: 6),
//    SavedPhoto(color: "Donut_Colorfull",  image: 7 ),
//    SavedPhoto(color: "Donut_Dark",  image: 8)]

