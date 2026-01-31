#include <wx/string.h>
#include <wx/datetime.h>
#include <wx/filename.h>
#include <wx/gdicmn.h>
#include <iostream>

int main() {
    // 1. wxString
    wxString str_ascii = "Hello wxWidgets";
    wxString str_unicode = wxString::FromUTF8("你好 wxWidgets");

    // 2. wxDateTime
    // Use a fixed date for stable testing: 2023-12-25 13:30:45
    wxDateTime dt_fixed(25, wxDateTime::Dec, 2023, 13, 30, 45);

    // 3. wxFileName
    // Note: Use simple paths to avoid platform separators issues in simple regex
    #ifdef __WINDOWS__
    wxFileName fname("C:\\Projects\\MyApp", "readme.txt");
    #else
    wxFileName fname("/home/user/projects", "readme.txt");
    #endif
    
    // 4. GUI Types (wxPoint, wxSize, wxRect)
    wxPoint pt(10, 20);
    wxSize sz(800, 600);
    wxRect rect(10, 20, 800, 600);
    
    // Stop here to inspect variables
    std::cout << str_ascii << std::endl; 
    
    return 0;
}
