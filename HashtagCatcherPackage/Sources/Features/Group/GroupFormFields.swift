import SwiftUI

struct GroupFormFields: View {
    @Binding var groupName: String
    @Binding var hashtags: String

    var body: some View {
        Text("グループ名", bundle: .module)
            .font(.body.bold())
        TextField("", text: $groupName)
            .frame(width: 300, height: 32)
            .overlay(RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.gray))
        Text("ハッシュタグ", bundle: .module)
            .font(.body.bold())
        TextEditor(text: $hashtags)
            .frame(width: 300, height: 200)
            .overlay(RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color.gray))
    }
}
