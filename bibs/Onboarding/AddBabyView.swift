//
//  AddBabyView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AddBabyView: View {
    var body: some View {
        NavigationLink(destination: AddBabyConfirmationView()) {
            Text("Next")
        }.navigationBarTitle("Hi there")
    }
}

struct AddBabyView_Previews: PreviewProvider {
    static var previews: some View {
        AddBabyView()
    }
}
