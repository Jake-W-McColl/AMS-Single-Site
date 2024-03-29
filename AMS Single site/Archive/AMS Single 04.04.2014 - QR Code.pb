;/ AMS FMP replacement project.
;/ Phil James for Troika-Systems Sept 2011 - 

;/ Database stores Values as LPI, CM3/M2 & Microns - all required conversion is done at software level when outputting values to the relevant forms, based on chosen settings

;/ 1 thou = 25.4 microns
;/ 1 cm3 = 1 millilitre(ml) = 1 CC = 1.55 BCM

;{/ Update History From October onwards:-

;/ 05/10/2011
;/  1. Double click on reading brings up the relevant reading editor.
;/  2. Selecting a Group on the NavTree now lists assigned Rolls to that group.

;/ 06/10/2011
;/  1. Added a Suitability Database (AMS_Suitability) to select Suitability options from, rather than Free-Keying - Right-Clicking allows creation of new suitability types.
;/     - Required adding to Roll Information Window, amended 'Update Rollmaster' procedure to read Suitability combobox value, rather than text
;/  
;/ 07/10/2011
;/  1. Added AMS_Report_Presets Database, to hold presets of reporting filters in future releases
;/  2. Added GUI elements of Reporting filters
;/
;/ 08/10/2011
;/  1. Change Manufacturer type from Char to Database Reference 
;/    - Created database table (AMS_Manufacturers)
;/    - Changed Roll info screen to use Combobox
;/    - Loading manufacturer list during Database_Load_Settings
;/    - Roll Info form manufacturer updating uses getstate instead of gettext.
;/  2. Added a 'Last Reading Date' field to AMS_Roll_Master - Will enable report generation of Aniloxs that require readings
;/    - Amended AMS_Import procedure to update this field
;/    - Amended Init_Window_Readings_Edit to update this field.
;/  3. Added Group form - to show list of assigned Rolls and vital statistics
;/  4. Add Site Form - Uses Group Form, but lists all Groups & associated rolls
;/  5. Fixed search to include Sites & Groups as well as RollID Names
;/
;/ 09/10/2011
;/  1. Added Manufacturer list editting  + associated database update functions - On settings screen
;/  2. Added Suitability list editting  + associated database update functions - On settings screen
;/  3. AMS import now includes AMS image import routines (TopSnapImage form original and HistoricalTopSnapImage for historical)
;/  4. Manually import Image into roll master (to accompany the manual inputting of data)
;/    - Additional Menu entry added to image popup menus
;/  5. Application Launch Splash Screen
;/  6. F11 for quick Full-Screen view - Slow at the moment - needs a speedup
;/  7. Refresh RollID procedure to properly Update imagery
;/  8. Gave the Reporting screen some colour, still greatly unfinished.
;/
;/ 10/10/2011
;/  1. Began routines for unit conversion - text now changes on report & roll id windows to reflect settings.
;/
;/ 12/10/2011
;/  1.  Fixed bug in code generator in unicode mode.
;/
;/  ... Sandon trip & weekend
;/
;/ 17/10/2011
;/  1.  Fixed AMS Import failing on non-averaged exports
;/  2.  Fixed Search selection not populating internal RollID variables (required for AMS file import RollID matching)
;/  3.  Fixed width of readings fields to allow 5 chars including decimal point (999.9)
;/  4.  Fixed Report view not showing any Capacity if no historical readings are present
;/  5.  Added automatic popup tooltip on RollDamage list (requested by Nigel@Sandon)
;/
;/ 18/10/2011
;/  1.  Changed Database structure to hold images for all readings - amended many lines of code to implement this.
;/  2.  Added Manual import of images
;/  3.  Removed Unneccesary buttons from Roll Info Screens
;/
;/ 19/10/2011
;/  1. Added 'Suitability' field on Report screen.
;/  2. Added 'Last reading Date' field on Report Screen
;/  3. Added Report_Add_Group_Detail procedure - otherwise we'll be replicating code for Group only views & Site views - this means only have to change one procedure, rather than two in future.
;/
;/ 20/10/2011
;/  1. Added Site info window (right-click site menu)
;/  2. Enlarged Scan images on Roll Info screen.
;/  3. Double-Clicking Roll Damage now initiates edit mode
;/  4. Changed all 'Press' texts & Database fields to read 'Groups'
;/
;/ 21/10/2011
;/  1. Added Drag & Drop To NavTree
;/  2. Stress tested - 100 groups created, each with 100 rolls (10,000 rolls) - NavTree heirachy loads in ~2 seconds - Filesize (with no historical readings) is 737meg.
;/  3. Changed the Group field on Roll Info window to be a combobox, allows control of assigned Group.
;/
;/ 22/10/2011
;/  1. Store Report-Line > RollID relationship, will allow drilling into RollID from Report screen by double-clicking:
;/      - Create new linked List: ReportLine_RollID() - Flat List of Integer type.
;/      - In Redraw_Report() Procedure
;/         	Clear the linked List ReportLine_RollID()) at initialization stage.
;/      - In Report_Add_Group() Procedure
;/         	Where RollID > 0 (So line corresponds to a Roll and nothing else)
;/         		Add element To ReportLine_RollID()
;/         		Store RollID in new ReportLine_RollID() element
;/      - In Process_Events() Procedure
;/         	Detect Double-click event on Report_List Gadget
;/         	Select ReportLine_RollID() element based on what line was double clicked (GetGadgetState())
;/         	If ReportLine_RollID() > 0 (So was a Roll line that was double-clicked
;/         		Set NavTree To Corresponding RollID
;/         		Call Redraw_RollID() With our selected RollID
;/         		Show Roll Information Window
;/  2. Front Page Changes now includes Site information
;/
;/ 24/10/2011
;/ 1. Added report preset combobox to report
;/ 2. Remapped window colour to constants for easier changing in future
;/ 3. Added new table to database to store Report filters, will allow report cusomizations in future release
;/  
;/ 25/10/2011
;/ 1. F11 fullscreen quick-view toggle - (F11 to enter, F11 to exit)  - Pushes image out of aspect ratio, but good for viewing).
;/ 2. Ctrl+I implemented for Master Import - This will Automatically import AMS file onto relevant RollID
;/    - Rejects import if RollID is Blank
;/    - If RollID exists already will import readings into that RollID
;/        Else, it will automatically Create RollId (in unassigned pool - If RollID name is Not null And is Not currently in Database.)
;/    - *Navigation* - View automatically updates to Imported RollID.
;/
;/ 26/10/2011
;/ 1. Added 5x guide bar graphics leading from the Roll graphic to the relevant volume reading column.
;/ 2. Changed 'Damage list' text to read Anilox history.
;/ 3. Change 'Current' to 'Reference' on the Roll Info Screen.
;/ 4. On the Volume reading reference / history lists, Seperated the volume readings with an '=' column.
;/
;/ 27/10/2011
;/ 1. Replaced splash screen with placemarker AMS image.
;/ 2. Compressed included images (Icons, Roll graphic etc,.) - Executable now 20% smaller.
;/ 3. Cleaned Up report window gadgets to make them more fluid.
;/
;/ 28/10/2011
;/ 1. Reformatted Settings window to be less cluttered - Now easier to use as settings are categorized.
;/ 2. Cleverly(?) handled Apostrophes / SpeechMarks in SQL String statements (which are normally encapsulated with apostraphes) - Used a macro to edit the string before it's sent to the database update routine
;/
;/ Weekend with son.
;/
;/ 31/10/2011
;/ 1. Warn if not committed when changes have been made
;/    - When reading roll info from database, data is stored in a structure
;/    - Check if data still identical on every edit of relevant gadgets - If editted, show the Commit/Undo buttons
;/    - Also, if editted flag is set, prompt to commit the changes if leaving the RollInfo screen.
;/ 2. Report Screen Work
;/      - filters are now active, but need a method to edit them.
;/      - sort order & direction now live
;/ 3. Added code to hide the 'Commit' panel if not requred - only shown if changes have been made
;/      - this gives a visual indicator that changes have been made and that committing the changes is required.
;/
;/ 01/11/2011
;/ 1. Began work on Preset Editor - Window designed, Dialog boxes designed & populated - Some logic in place.
;/
;/ 02/11/2011
;/ 1. Fixed crash bug where the RollID is dragged to the last group & updating (crash actually occured when redrawing the Roll Info screen).
;/ 2. On Report, selecting 'Flat' from report style when over site will produce a flat list, with an additional 'Group' column at the end.
;/
;/ 03/11/2011
;/ 1. Removed decimal places on Variance & capacity % on Roll Info (Report is still showing the decimal point).
;/ 2. Changed roll width field to show MM rather than CM.
;/ 3. Uppercased BCM
;/ 4. Changed Sort order for historical readings, so latest reading is on top - more work than expected!
;/ 5. Replaced group dropdown on Roll Info window with a textbox.
;/
;/ 04/11/2011 - early wake up!
;/ 1. When adding a new preset, it now allows you to select an existing preset as a template.
;/ 2. Fixed Fullscreen mode to stay within the aspect ratio of the image
;/ 3. When showing historical readings - ensured the default roll image showin is the topmost historical reading. (due to new sort order)
;/ 4. When trying to manually add images to historical imagegadget, warn if no historical readings present, rather than ignoring.
;/
;/ Weekend 05/11 - 06/11
;/
;/ 1. Added Company table to Database - this is the detail that's now shown on the homescreen.
;/ 2. Added company information editor - seen on the homescreen - Right click the company name in the navtree and select 'Edit'.
;/ 3. Added Site info editor - right click site and choose 'Edit' option.
;/ 4. Refresh homescreen procedure now in place (to accomodate editing functions)
;/ 5. Bugfix: Changes in sort order had lead to some variables not being populated correctly, causing SQL issue on new import
;/ 6. Bugfix: Fixed colouring on Roll Info page (Reference & historical list variance - had been offset by the addition of the '=' column.

;/ 07/11/2011
;/ 1. Made the ListIocnGadgets scale to screensize - now need to work on scaling the fonts & images
;/ 2. Changed the 'Anilox General history' record dialog box, now has one less column, but allows for all details to be inputted, not just damage records
;/ 3. Removed some redundant / inactive menu entries
;/
;/ 08/11/2011
;/ 1. Changed 'Code' field to allow limitation on number of rolls & number of records on rolls.  
;/ 2. Roll/Reading limitations Default set to 10 rolls & 5 readings per roll.
;/ 3. Adding manual reading to roll - have taken away the reading count dropdown - now automatically detect which fields are populated and which aren't
;/ 4. Save Image in the 2x image menus.
;/ 5. Prevented the Roll pointer images from stealing the original readings/ historical readings events...
;/
;/ 09/11/2011
;/ 1. Added Image Scaling to the window resizing routine.
;/ 2. Added font Scaling to the window resizing routine... can now edit font & font sizes if needs be (in code only, no editor).
;/ 3. Added a 'Save Image' option to the 2x scan images, on right-click menus
;/ 4. Fixed bug where group text doesn't update when changing assigned group on Roll Info screen.
;/ 5. Fixed bug where the Comments box font didn't adjust scale with window resizing, this was due to the getgadgetfont command being incompatible with editorgadgets.
;/ 6. Optimized the drawing of Roll Information a little.
;/
;/ 10/11/2011
;/ 1. Bugfix - Report Screen - Suitability, if not set, was inheriting previous rolls suitability.
;/ 2. Began working on implementing language tools - sequence will be:
;/      - writing a program that extracts all strings being used (edittin main source to include ;/DNT at the end of lines that need to be excluded from the language conversion
;/      - from the extracts:
;/          - build a constant List (#Text_...), where ... = text string that requires translating
;/          - Build a new database (Language.DB), Fields: OriginalText, German, Spanish & French - populate with the translatable strings
;/          - Write a google translation tool to automatically populate additional languages frmo OriginalText (English)
;/          - Add T_Text() array to the main source, this array will be populated from the Languages database, based on language selection.
;/      - Parse main source & replace all translatable strings with T_Text() array and relevant '#Text_...' constants.
;/      - 
;/      - 
;/ 11/11/2011
;/ 1. First Exporting procedure completed, CSV files on the Report screen can now be generated...
;/ 2. Added some API that forces stringadgets that are tabbed into to have the whole text selected.
;/
;/ 12th & 13th/11/2011
;/ 1. Began work on PDF exporting functions - lots of work as using proprietry code to create PDF format documents from scratch - not using library.
;/ 
;/ 14/11/2011
;/ 1. Fixed bug where Homescreen Group count was querying the wrong database table (duh!)
;/ 2. Exporting to CSV from the Roll Information screen is now live.
;/
;/ 15-17th/11/2011
;/ Continuing PDF implementation, cannot add alpha-channel images.... need to make completely opaque set??
;/
;/ 18/11/2011.
;/ Continuing PDF implementation....
;/ Removed CSV & XLS exporting, as per PH request.
;/
;/ 21/11/2011
;/ Changed settings list to a treegadget in order to categorize them
;/
;/ 22 - 27th - European trip
;/
;/ 28/11/2011
;/ Added filter used & Date generated to PDF output.
;/
;/ 29/11/2011
;/ Fully Categorized Settings window
;/ Added a 'Result count' string when creating report presets - this allows validation when generating new presets
;/
;/ 30/11/2011
;/ Added database version checker
;/    - this will allow amendments To the core of the database without affecting existing database Data
;/    - Checks current version against new version and makes necessary changes dynamically.
;/ 
;/ 01/12/2011
;/ Some bugfixes - Fixed possible failed database commit due to US date format in AMS export string
;/ working on Automatic Import routine (Live export monitoring)
;/

;/ 02/12/2011
;/ Unified AMS import routine so only have to maintain one (was in both Import_AMS & Import_AMS_Master)
;/ Adjusted settings window To include Import Path amendments & Automatic Import toggle (Live export monitoring)
;/ On Import, if roll fields (Screencount, Cell wall & opening are empty, they are now populated using imported figures.
;/ Added a Minimize to System tray function - This can be used as a 'background' mode when live monitoring is enabled
;/ Added System-Tray balloon popup for messaging
;/ 
;/ 02/12/2011 (#2!)
;/ Forced a single instance of the application (helpful when the AMS is minimized!)
;/ Replaced all 'Okay's with 'OK'
;/ Fixed bug in Automatic Import routine whereby the reading count was being checked against the currently selected roll, not the imported roll.
;/ Only create the System Tray Icon when AMS in minimized to the System Tray & Remove System tray icon when window is restored.
;/ Can double-click the system tray icon to restore.
;/ 
;/ 05/12/2011
;/ Added an 'Delete after import' flag to the AMS_System table
;/ Added Import_Delete flag to the system structure
;/ 
;/ 06/12/2011
;/ Re-wrote the CSV export code for Roll report..... why didn't I keep my original code???
;/
;/ 07/12/2011
;/ Wrote some export 'direct to excel' code - Very interesting, allows export to excel without the file load / save inbetween
;/ Added Cursor key navigation (Ctrl + Cursors)
;/
;/ 08/12/2011
;/ Direct export to Excel is working for the Roll Report.
;/
;/ *Spain*
;/
;/ 14/12/2011
;/ implemented proper cursor key control for navigating the navtree & RollInfo history lists
;/ Implemented Delete key on both Navtree and RollInfo History list for deletion of records
;/
;/ 15/12/2011
;/ Lowered down the Navtree & Troika Image panel to allow for Icons to be implemented
;/ Split the Roll Image into 2 seperate pieces to prevent flicker when changing from different historical readings
;/ Drew some (Temporary?) new icons to represent export options on main page
;/
;/ 16/12/2011
;/ Added 4 icons to main page - export to csv, xls, pdf & a quick-toggle for automatic import / export
;/ Added all support code so that Icons actually do something!
;/ Shrunk the initial window down to 720 pixels high, this is to ensure that we're compatible with x768 displays
;/    - As it was being cropped when testing with David Allen.
;/
;/ 17/12/2011
;/ Completed routine for 'Export to CSV' on RollInfo window
;/ 
;/ 18/12/2011
;/ Drew & Added Image Export icon, to allow Images to be exported
;/ Added Export to Image file procedure, which saves the image to a format of your choice.
;/
;/ 19/12/2011
;/ Extended the image export to include an export to clipboard routine.
;/
;/ 20/12/2011
;/ Extended image export further by allowing image to be inserted into an automatically created email (as an attachment).
;/ Ordered the 'General History' list into date descending order.
;/ Amended the Show Window procedure to grey out any exporting options which aren't available on that particular window
;/
;/ 21/12/2011
;/ Continued work on Exporting Rollinfo to PDF (Finally)
;/ Created Opaque PNGs for all images that appear on RollInfo screen, as PDF is not compatible with PNGs that have an alpha layer.
;/ Included in EXE all opaque PNGs
;/ PDF exporter now references opaque versions of the normal alpha images.
;/ Roll Info export to PDF finally completed
;/ 
;/ 22/12/2011
;/ Checked suitability lists & Manufacturer lists - possible crash if referencing a value that is outside of list size...
;/ Amended keyboard shortcuts to use menu options instead
;/ Translation work - a helper application written:
;/      1) Seperates special characters out of strings (i.e "Error:" becomes "Error"+":")
;/      2) Parses and tokenises all valid strings
;/      3) Creates an enumeration file for import
;/      4) Creates a text file for translation.
;/      5) Creates an AMS_Language.db database (prompts to overwrite if already exists)
;/      6) Creates a new source code from the original source, replacing all valid strings with string references
;/ 
;/ 23/12/2011
;/ Supplemental Application - Language Database Editor, WIP
;/ Tidied up menus a little
;/ Amended code entry routine, only allows saving on valid code input
;/
;/ 24/12/2011
;/ Implemented an update checker
;/    Downloads a small text file from our webserver, in this format:
;/      Line 1: Internal version (Integer Numeric, increments with each new release)
;/      Line 2: External version (Version in text form, it's what the end-user sees)
;/      Line 3: (& onwards) All Update information text.
;/    Once processed, user is prompted if they're up-to-date, or if there's a newer version to download.
;/    If there's a newer version to download, update information is given
;/      and a 'Download now' button links to our webserve for manual download.
;/
;/ Xmas - Language implementation
;/
;/ 04/01/2012
;/ Separated Language database into individual files (In Languages directory)
;/ Language editor re-written To support separate files
;/ AMS Main application amended To support separate language files.
;/
;/ 05/01/2012
;/  PDF export retaining images from viewed scans if current scan had a 'no image found' image - removed.
;/  Tables on PDF export were scaling with window - Fixed
;/  Removed some translations from SQL statements that clearly shouldn't have been there.
;/  Added font settings to Language editor
;/
;/ 06/01 - 08/01
;/  Fixed: a handfull of SQL statements got caught by the translation script ('And' translated to 'Und') - Caused SQL errors.
;/  Fixed: '*Unknown*' string in manufacturers list had been incorrectly omitted from the translation script.
;/  Language Editor: If reference string is blank, it omits it from showing in the list - means that strings where translations are no longer required can be hidden away.
;/  Created standalone application for HR to test the XLS export functions, as they weren't functioning on his PC.
;/ 
;/ Beta 1a
;/ 09/01/2011
;/  Moved Icons to the bottom of the navtree panel (PH Request)
;/  Worked with HR til gone 18:00 for fix on XLS export problem
;/  Corrected error if trying to save a readings record with no readings... (shouldn't be saving blank records, but need to manage it if it does occur)
;/
;/ 10/01 - Training away - 8 hours including travelling (stuck on M4 on way up due to accident - Left at 7am, arrived at Apex @ 9:45)
;/  Added error description checking on OLE/COM export routines to hopefully identify HRs export problem.
;/  PH: Database Company name -> 'Beta 1 - Language Test'
;/
;/ 11/01/2012 - Finished @ 5pm due to support call from Ken @ Provident + Daughter ill...
;/
;/ 12/01/2012 - 15:50 finish + dropoff of Junaedi & Sunitsa
;/  Fixed HTTP update check address string being in language translation files - now fixed string
;/  Added a procedure to check a version number of the language database files, will allow the control of additional fields as and when required.
;/      0 = Base database, will add a version field (set it to a 1), a delimiter field defaulting to 0 (decimal point), and a CSV seperator field defaulting to a 0 (comma)
;/  Added an option on the language editor to show strings which are identical in both the reference and editting files, handy when looking for newly added strings (as all in English by default).
;/  Added CSV Delimiter to Settings Page (Under General / Languages)
;/  Added Decimal notation to Settings Page (Under General / Languages)
;/  Added text string error if trying to save reading record that has a zero value
;/  Changed all hard-coded database open, query and update commands to use enumerated references.
;/
;/ 13/01/2012 6:30AM & 16:00 onwards
;/  HR BugFix: Fixed bug whereby references to suitability list referenced actual position on the list, rather than referencing directly the database Record ID.
;/    3 * new procedures to accomodate: Get_Suitability_Text, Get_Suitability_Value & Get_Suitability Index.
;/  Bugfix - Linked to HRs Suitability list find above, the Manufacturer list was behaving the same way - now fixed.
;/  Bugfix, Show Image 2d now picking up reference and historical images correctly.
;/
;/ 15/01/2012 - Sunday AM
;/  PH Request - Have now encrypted the Company Information database & have removed internal editting facilities
;/    Wrote a tool (Database Prepper) that allows the editting of this information + set limits.
;/  Fixed a bug with the image scaling (On Form_Update_Images) whereby it was reducing the horizontal size of the Homescreen Roll bar by 4 pixels each time it was called (eventually ending up as < 0, causing a crash)
;/  Language Editor Change.  If English database holds more records than other languages, new records must be created to address the imbalance, inheriting English strings.
;/    This has been implemented in both the main application and the language editor.
;/  
;/ 16/01/2012
;/  - AM
;/  Added procedures for GUI control and database updating of CSV export delimiter / Decimal notation.  AMS_Language_Master.
;/  - PM
;/  Bugfix: Fixed Bug on report filter control - similar issue as last weeks manufacturer/suitability list?
;/  Tested update of database when database records are mis-aligned
;/  Amended Language editor for importing new text files as it was still set up for unified database
;/  PH Request: - Created 2 new language files (Turkish & Portugese)
;/  PH Request: - Removed Chinese language.
;/  HR Request: - Can choose between Comma and Tab delimiter for CSV export
;/
;/ 17/01/2012
;/  PH request: - Removed 'Show 2d / 3d" options from right-clicking scan images.
;/  PH request: - Removed Show site information & edit site information
;/  Removed 'Import ACP' button from rioll information screen.
;/  Implemented 'Manager Mode'.  This restricts certain functions unless the password enabled Managers Mode is used.
;/    Add, Edit or rename a Group
;/    Edit a roll name or delete a roll
;/    Edit a Roll reading, or deleting of a roll reading (reference or historical)
;/    Variance Warning values & Capacity warning values in the settings window.
;/  Bugfix: Export to PDF, the historical reading image wasn't being displayed.
;/ 
;/ 18/01/2012
;/   Core EULA window created, populated with some test data at the moment.  Awaiting revised EULA text from PH.
;/   Bugfix:  Fixed an issue whereby, if a row was selected on the ref / hist list, the PDF export would expand the first field to the entire width of the list.
;/   Added 'View Licence Agreement' to help menu
;/   Disabled Export option on Menu if screen that is being viewed doesn't allow export.
;/   Bugfix: Fixed small bug in the Language Editor, whereby it wasn't automatically updating the Override text on the screen (although the database was being amended).
;/
;/ 19/01/2012
;/   The Decimal notation selection should now be effecting Roll Info screen & Roll Report screen
;/   HR: Fixed a bug (crash) if double clicking an empty record on the general history box.
;/   HR: Fixed bugs in Suitability list & manufacturer list when trying to set them to 'Unknown' and 'Not Set' respectively.
;/
;/ 20/01/2012
;/   Using German language, increased the size on some 'Cancel'  (Abrechen) buttons as were being cropped.
;/   Using German language, increased the size on some of the fields on the Roll information screen (Screen count, roll width etc,.) due to cropping.
;/   Tweaked the format of the Roll report PDF export, was a little untidy.
;/   Increased 
;/
;/ 25/01/2011
;/  Changed the About box to have a Troika logo and an AniCAM icon
;/  Fixed a bug in report mode where a flat report for a manufacturer value of 0 showed empty string.
;/  Enlarged a few gadgets on Report view to make it more language option friendly.
;/ 
;/ 30/01/2012
;/ Implemented extended AMS file format To take into account the date format - should now work okay in MMDDYYYY format.
;/
;/ 01/02/2012
;/ Added limitation values to the about box, for support purposes
;/ Optomisation:  Filtered the scale image procedure so that not all images are scaled all of the time.
;/ Date Format checking on AMS import - Look at current date format setting for guidance if not specified on AMS file
;/
;/ 06/02/2012
;/  Removed decimal points on Capacity and Variation on Roll Report screen
;/  Fixed bug with XLS export menu not being live.
;/  Fixed bug with manufacturer list using absolute references, rather than database references.
;/  Fixed bug with Suitability list using absolute references, rather than database references.
;/  Fixed bug whereby a roll ID with suitability / manufacturer value of null resulting in the report adopting any previously viewed values.
;/  Amended some field sizes to allow some language conversions to display.
;/
;/ 08/02/2012
;/  Added a BOM (Byte-Order-Marker) to the CSV export file, this ensures UTF-16 compatibility.
;/  Amended PDF file format For proper inclusion of the font chosen in language database file.

;/ 09/02/2012
;/  When deleting a roll, the screen will now redraw onto the new navtree selection.
;/
;/ 16/02/2012
;/  Added timing checks to allow analysing of time taken
;/  Now refreshing manufacturer and suitability lists when changing languages
;/  Fixed: Last roll viewed not automatically redrawing when language changed
;/  Removed header line from reference reading, to prevent resizing
;/
;/ 21/02/2012
;/  Added enumerations for text alignment controls
;/  Added Text centering on volumes on Roll Info as per PH request.
;/  PDF_End() added to Export_Rollreport, to free allocated memory (memory leak otherwise).
;/  Sped up the Navtree refresh time from 6770ms to 62ms (over 100x) on a stress test database of 4 sites, 32 groups with 7000 aniloxes total.
;/  Adjusted field sizes for thai translations
;/  Added a couple of full translation strings, rather than compund single strings.
;/
;/ 28/02/2012
;/  Re-routed the database files so that they should be located in the Userdata area of Windows.
;/  Changed the language editor to pick up the language files from the UserData area of windows also.
;/
;/
;/ ************** Release version 1.0 ******************
;/
;/ 16/03/2012
;/ Planning out Multi-site change requirements:
;/ Settings_Checkversion
;/ Database_LoadSettings
;/ Database_SaveSettings
;/ Database_Create_Site
;/ Database_Rename_Site
;/ Init_Settings:
;/ All database queries and updates require site methodology
;/ etc,.
;/
;/ 19/03/2012 - MS
;/ Database_LoadSettings procedure amended to read from localised settings file if Multi_Site_Mode flag is set
;/    Generate localised settings file if it doesn't exist.
;/      create Database file, add table, populate table.
;/ Database_SaveSettings procedure amended to save to localised settings file if Multi_Site_Mode flag is set
;/ 
;/ 20/03/2012 - MS
;/ Create & Delete Site are now partially functioning.
;/ Added 'Default site' control, for automatic importing etc, the system needs to know what site it is working with.  Still needs the import logic control updating.
;/
;/ 21/03/2012 - SS (found during GTM with Alan Whatley)
;/ Fixed filter bug whereby the 'Showing ## of ##' text wasn't giving the correct information.
;/ 
;/ 22/03/2012 - SS (PH visit to Lahore)
;/ Fixed: When deleting a roll, any assigned General history records were not getting deleted, so when a new roll is created with the same ID, they'd re-appear.
;/ Changed: When applying a licence code update, a full screen refresh is activated, so it displays the new data without the need to restart.
;/ Changed: When applying a licence code update, if the site name is 'Orion Flexo' then it will be overwritten with the company location text.
;/ 
;/ 23/03/2012 - MS
;/ Site Delete now fully functional
;/    Force delete option added to Group delete function to ignore Group type (so 'Unassigned' group can be deleted)
;/ Creating a Roll now only references that particular site for checking duplicated names
;/ Creating a Group now only references that particular site for checking duplicated names
;/ 
;/ 24/03/2012 - MS
;/ Automatic import now being assigned to the correct (Default) site.
;/ Adjusted the Auto-Import routine to display the site it's being imported into.
;/
;/ 26/03/2012 - MS
;/  Adding Timestamp fields to the main database, Tables: AMS_Sites & AMS_Groups - this can control automatic screen refreshing.
;/ 
;/ 27/03/2012 - 29/03/2012 - MS
;/ Working on setting & getting timestamp routines + where & when logic.
;/ 
;/ 30/03/2012 - MS
;/ Finalised & switched on Auto-update logic, success!
;/ 
;/ 02/04/2012 - MS
;/ Added 'Seconds' text to settings, added routine that requests database path selection if database couldn't be loaded (+on settings)
;/
;/ 03/04/2012
;/ Added Roll Export & import routines, primarily for PH to transfer older demo data to multi-site database, but could be handy to have elsewhere.
;/ Restructured the draw / Show order, which reduces flickering.
;/ 
;/ 04/04/2012
;/ Fixed a memory leak in Image_Refresh_History() Procedure
;/
;/ May / June 2012
;/ 
;/ Added depth values, so are now stored and displayed - requested by Dave Allen & Mark Chapman.
;/ Manual importing made easier by remembering the last inputted operator in the session.
;/ Added a new '+' button next to Import:AMS to add manual reading
;/ Changed Image import to convert any non-jpg file to jpg - fixes some incompatibilities and also shrinks database writes.
;/ Now remembers last imported image path.
;/ Some bespoke code amendments to support the 24 roll limit version.
;/ Fixed font scaling in Report query editor.
;/ 
;/ ************** Release V1.1 - July 15th 2012 ****************
;/
;/ October 2012
;/ Encapsulated the Preset query so that it's seperated from the main selection query - caused duplicated results otherwise.
;/ Added /CAP_GOOD/, /CAP_BAD/, /VAR_GOOD/ and /VAR_BAD/ to query controls.
;/ Now sorting the navtree lists into alphanumeric order, as per PH request.
;/ Changed the maximum Roll Count on front screen to show 'Unlimited' if the roll limit is set to 99999
;/
;/ November 2012
;/ Added the ability to create additional sites (if licence allows) 
;/      *This is really for PH only - So that the scans taken from his site visits can be better organized (requires 'MS' in filename)*

;/ Reduced the amount of images in the Images directory (Cleanup)
;/ Removed the need for a Cropped logo to be included, now just use a scaled full-size logo.
;/ Added colouring to PDF Roll Information report (why wasn't it there before??)
;/ Centre justified PDF Roll Information report tables, readings now align better with the Roll & pin images.
;/
;/ December 2012
;/ AMS can now be customized to show OEM logo on front screen & reports.
;       Requires 'OEM Logo.jpg' or 'OEM Logo.png' in the OEM directory.  Also OEM Weblink.txt for own weblink.
;/ Added OEM logo to PDF report.
;/ Added built-in Printer routines, along with a new printer icon on the icon bar.
;/ Adjusted direct-Print layout for Roll overview reports - moved some information to the top of the screen, alongside the company logo.
;/ Adjusted Roll overview report to allow for column resizing.
;/ Group report view shows a comment
;/ Added proper text wrapping for comments printout
;/
;/ January 2013
;/ Bugfix on the Commit / Undo feature
;/ Ensured all relevant sub-windows are correctly parented to main window
;/ Set all sub-windows that have a parent are set to Window Centered, rather than Screen Centered (Good for multi-screen setups).
;/ Flush keyboard buffer before opening any editting windows - caused an edit window to open & instantly close on first run.
;/
;/ February 2013
;/ Added 2 decimal places when in BCM mode if the volume is under 10BCM.
;/
;/ March 2013
;/ Bugfix - Making a change to roll info, then moving off and answering 'yes' to updating it, updated the newly selected RollID, not the originator.


;/  ************ Change Requirements: Additions to the settings window? ***********
;/ If an addition to the settings is required, changes are needed in:
;/   The System structure for the new flag / flags
;/   The Gadget Enumerations for any new gadgets on the settings window
;/   Init_Settings() procedure to allow displaying & interacting, on the settings window 
;/   Database_LoadSettings() Procedure to add the writing of the new setting
;/   Database_SaveSettings() Procedure to add the reading of the new seeting
;/   Amendments to the program to ensure that the setting is effecting whatever it needs to
;/ 
;/  **** From 04/01/2011 - Any text string additions now have to go through the following changes: ***
;/ Additional entry into all existing language database files required for each *new* string
;/ Additional entry into the Enumeration include required for each *new* string - Line# MUST match that of database entry.
;}

;{/ *!* To Do *!*
;/ ************************** *!* To Do *!******************************************
;/ New Date control for PH to restrict updates after 12/13 months... how to implement?
;/    Possibility of adding a Month value to the encrypted code in the Settings table
;/    Add an internal Month value to each AMS update released - This could check the Database value to determine if it's outside of allowed update time.
;/ Add reporting of usage frequency:
;/    How many scans today
;/    How many scans in the last 7 days
;/    How many scans per month / site
;/ *********************************************************************************

;/ Threading for database retrieval - will speed up refresh and allow quicker reselection if required (especially on Multi-site networked mode)
;/   Need threads for: Database Roll Info Data, Database Roll Info Images & Database Roll Report.
;/ Database Trim routines - for controlling size of database
;/    - I.E. Remove all TopImageSnaps from historical readings that're > 1 year old.
;/
;/ Add sanity checking on importing routines (AMS or ACP), if import data differs greatly from existing data (Volume, LPI etc) have warning.
;/ ACP Import - File and Directory.

;}

EnableExplicit

ImportC "sqlite3.lib" ;/ have to import this as not part of normal functionality
  sqlite3_last_insert_rowid(hDB.l) 
EndImport

;/ *** This is the version number that is used for the lookup on the AMS-Update.txt ***
Global Program_VersionI.i = 2 ;/ 
;/ ************************************************************************************

Global Program_Version.s, Multi_Site_Mode.i, Multi_ForPhil.i

If FindString(UCase(GetFilePart(ProgramFilename())),"MULTISITE")
  Multi_Site_Mode = 1
EndIf
If FindString(UCase(GetFilePart(ProgramFilename())),"MS")
  Multi_ForPhil = 1
EndIf

;Multi_Site_Mode = 1 ;/ Flag to control whether the program is in single-site or multi-site mode
#Force_Single = 0 ;/ a flag for Phil if he wants to demonstrate user / manager mode on a single PC.

XIncludeFile("AMS Language Enumerations.PBI") ;/ controls the text translations

If Multi_Site_Mode = 0
  Program_Version.S = " V1.25 - Single-Site " ;/DNT
Else
  Program_Version.S = " V1.24 - Multi-Site " ;/DNT
EndIf

;/ ** Includes **
#PurePDF_Include = 1
#Program$ = "AMS" ;/DNT

Global IniSwitch_NoAdmin.i = 0, IniSwitch_ReportDepths.i

Procedure CheckIni()
  Protected Txt.s, Arg.s, Val.i
  If ReadFile(1,"AMS.ini")
    Repeat
      Txt.s = ReadString(1)
      Arg.s = UCase(Trim(StringField(Txt,1,"=")))
      Val = Val(Trim(StringField(Txt,2,"=")))
      Select Arg.s
        Case "NOADMIN"
          IniSwitch_NoAdmin = Val
        Case "REPORTDEPTHS"
          IniSwitch_ReportDepths = Val
      EndSelect
    Until Eof(1)
    CloseFile(1)
  EndIf
EndProcedure
CheckIni()

Procedure AlreadyRunning() ;/ Procedure to prevent more than a single instance of AMS running
  ; Ensure the current program is not already running
  ; Terminate this process if it is
  ; Uses #Program$
  Protected app, msg$
  app=CreateSemaphore_(0,0,1,"Troika-Systems "+#Program$) ;/DNT
  If app<>0 And GetLastError_()=#ERROR_ALREADY_EXISTS
    CloseHandle_(app) ; This line can be omitted
    MessageRequester("Sorry","You should not be running more than one instance of the AMS application.", #MB_ICONERROR)
    End
  EndIf 
EndProcedure

XIncludeFile "Includes\PurePDF.pb" ;/DNT
XIncludeFile "Includes\COMatePLUS_Residents.pbi" ;/DNT
XIncludeFile "Includes\ComatePlus.pbi" ;/DNT
XIncludeFile "Includes\ExcelConstants.pbi" ;/DNT
XIncludeFile "Includes\ExcelFunctions.pbi" ;/DNT
XIncludeFile "Includes\UserAdminCheck.pbi" ;/DNT

If IniSwitch_NoAdmin = 1
  If Not IsUserAdmin()
    If RelaunchAndElevate()
      End
    Else
      End
    EndIf
  EndIf
EndIf

AlreadyRunning()

#Debug = 0 ;/ controls debug tab & splash screen etc.

#HW_PROFILE_GUIDLEN = $27
#MAX_PROFILE_LEN = $50

;/ Initialisation of subsystems

;/ Initiate libraries for encoding & decoding of JPEG & PNG files
UseJPEGImageDecoder() : UseJPEGImageEncoder() 
UsePNGImageDecoder() : UsePNGImageEncoder()

;/ Initiate Network environment - Required for downloading update text file.
InitNetwork()

Debug GetHomeDirectory()
Debug GetTemporaryDirectory()
;MessageRequester("Msg",GetCurrentDirectory())

;{/ Enumerate all windows / menus / gadgets / databases etc,.
Enumeration ;/Windows
  #Window_Main
  #Window_Splash
  #Window_Settings
  #Window_About
  #Window_Report
  #Window_EULA
  
  #Window_GroupAssign
  #Window_GeneralHistory
  #Window_Readings
  
  #Window_Edit_ManufacturerList
  #Window_Edit_SuitabilityList
  
  #Window_Presets
  #Window_SiteInfo
  #Window_Code
  #Window_FullScreen
  
  #Window_UpdateCheck
  
  #Window_CompanySiteEditor
  
  #Window_PasswordRequester
  
EndEnumeration
Enumeration ;/Menu Items
  #Menu_File
  #Menu_File_Export
  #Menu_File_Export_PDF
  #Menu_File_Export_CSV
  #Menu_File_Export_XLS
  #Menu_File_Export_Image_ClipBoard
  #Menu_File_Export_Image_Email
  #Menu_File_Export_Image_File
  
  #Menu_File_PrintPreview
  #Menu_File_Print
  #Menu_File_Quit
  
  #Menu_Options
  #Menu_Options_Settings
  #Menu_Options_MassMove
  
  #Menu_Options_Admin_Mode
  #Menu_Options_Superuser_Mode
  #Menu_Options_Edit_Manufacturers
  #Menu_Options_Edit_Suitability
  
  #Menu_Help
  #Menu_Help_About
  #Menu_Help_Input_Code
  #Menu_Help_Input_Code_Export
  #Menu_Help_Input_Code_Import
  #Menu_Help_CheckForUpdates
  #Menu_Help_ViewEULA
  
  #Menu_Popup0_Company_Rename
  #Menu_Popup0_Add_Site
  #Menu_Popup0_Edit_CompanyInfo

  #Menu_Popup1_Add_Group
  #Menu_Popup1_Edit_SiteName
  #Menu_Popup1_Show_SiteInfo
  #Menu_Popup1_Edit_SiteInfo
  
  #Menu_Popup1_Delete_Site
  
  #Menu_Popup1_SetasDefaultSite
  
  #Menu_Popup2_Add_Roll
  #Menu_Popup2_Group_Delete
  #Menu_Popup2_Group_Rename
  
;  #Menu_Popup3_Roll_New
  #Menu_Popup3_Roll_Unassign
  #Menu_Popup3_Roll_Assign
  #Menu_Popup3_Roll_Rename
  #Menu_Popup3_Roll_Delete
  
  #Menu_Popup5_GeneralHistory_Insert
  #Menu_Popup5_GeneralHistory_Delete
  #Menu_Popup5_GeneralHistory_Edit
  
  #Menu_Popup6_Original_Reading_Insert
  #Menu_Popup6_Original_Reading_Delete
  #Menu_Popup6_Original_Reading_Edit
  
  #Menu_Popup7_Historical_Reading_Insert
  #Menu_Popup7_Historical_Reading_Delete
  #Menu_Popup7_Historical_Reading_Edit
  
  #Menu_Popup8_Manufacturer_Insert
  #Menu_Popup8_Manufacturer_Delete
  #Menu_Popup8_Manufacturer_Edit
  
  #Menu_Popup9_Suitability_Insert
  #Menu_Popup9_Suitability_Delete
  #Menu_Popup9_Suitability_Edit
  
  #Menu_Popup10_ImportImage
  #Menu_Popup10_SaveImage
  #Menu_Popup10_ViewIn2d
  #Menu_Popup10_ViewIn3d
  
  #Menu_Popup11_ImportImage
  #Menu_Popup11_SaveImage
  #Menu_Popup11_ViewIn2d
  #Menu_Popup11_ViewIn3d
  
  #Menu_Popup12_ReportEditor
  
  #Menu_Popup13_Window_Restore
  
  #Menu_Popup14_ImageExport_ToClipBoard
  #Menu_Popup14_ImageExport_ToFile
  #Menu_Popup14_ImageExport_ToEmail
  
  #Menu_ShortCut_Master_Import
  
  #Menu_Force_Refresh
  
  #Menu_Navigate_LineUp
  #Menu_Navigate_LineDown
  #Menu_Keystroke_Delete
  #Menu_Keystroke_Debug
  #Menu_Keystroke_SQL
  #Menu_Keystroke_Export
  #Menu_Keystroke_Import
  
  #Menu_Popup_GroupBase = 1000
  #Menu_Popup_GroupBase_End = 9999
  
EndEnumeration
Enumeration ;/Images
  #Image_TreeView_Home
  #Image_TreeView_Plant
  #Image_TreeView_Group
  #Image_TreeView_Roll
  #Image_TreeView_Warn
  
  #Image_BorderRolls
  #Image_TroikaAMS
  #Image_BorderRolls_Scaled
  #Image_TroikaAMS_Scaled
  #Image_Info
  #Image_Roll
  #Image_Roll_Large
  #Image_Roll_Pins
  #Image_Roll_Large_Scaled
  #Image_Roll_Pins_Scaled
  
  #Image_AniCAM
  #Image_AniCAM_Opaque
  #Image_Factory
  #Image_Treeview_Factory
  #Image_Star
  
  #Image_Troika_Large_Logo
  
  #Image_Anilox_Opening
  #Image_Anilox_Screen
  #Image_Anilox_Roll
  #Image_Anilox_Wall

  #Image_Search
  
  #Image_Splash
  #Image_Logo_Opaque
  #Image_Logo
  #Image_Logo_Scaled
  
  #Image_OEM_Logo
  #Image_Temp
  #Image_Troika_Logo
  #Image_Troika_Logo_Scaled

  #Image_RollInfo_Screen
  #Image_RollInfo_Wall
  #Image_RollInfo_Opening
  #Image_RollInfo_Roll
  
  #Image_RollInfo_Opening_Opaque
  #Image_RollInfo_Screen_Opaque
  #Image_RollInfo_Roll_Opaque
  #Image_RollInfo_Wall_Opaque
  #Image_RollInfo_Roll_Pins_Opaque
  
  #Image_RollInfo_Original
  #Image_RollInfo_Referencel_Scaled
  #Image_RollInfo_Current
  #Image_RollInfo_Current_Scaled
  
  #Image_RollInfo_Sample
  
  #Image_2d_Image_Current
  #Image_2d_Image_Current_Scaled
  
  #Image_2d_Image_Reference
  #Image_2d_Image_Reference_Scaled

  #Image_3d_Image
  
  #Image_2d_Analysis
  #Image_3d_Analysis
  #Image_2d_Scaled
  
  #Image_FullScreen
  
  #NoImageLoaded
  #Image_AniCAMIcon
  
  #Image_Export_XLS
  #Image_Export_CSV
  #Image_Export_PDF
  #Image_Export_IMG
  #Image_AutoImport
  
  #Image_Padlock_Open
  #Image_Padlock_Closed
  
  #Image_PrinterIcon
  
EndEnumeration
Enumeration ;/Fonts
  #Font_List_Dialogs
  #Font_List_XS
  #Font_List_S
  #Font_List_M
  #Font_List_L
  #Font_List_L_Bold
  #Font_List_XL
  
  #Font_Report_Dialogs
  #Font_Report_XS
  #Font_Report_S
  #Font_Report_M
  #Font_Report_L
  #Font_Report_L_Bold
  #Font_Report_XL 
  
EndEnumeration
Enumeration ;/Gadgets
  #Gad_NavTree

  #Gad_TroikaButton
  
  #Gad_LHS_Container
  #Gad_SearchBox_Frame
  #Gad_SearchBox
  #Gad_SearchPrevious
  #Gad_SearchNext
  #Gad_SearchBoxText
  
  #Gad_Icon_Export_PDF
  #Gad_Icon_Export_XLS
  #Gad_Icon_Export_CSV
  #Gad_Icon_Export_IMG
  #Gad_Icon_Export_Print
  #Gad_Icon_Manager_Mode
  
  #Gad_AutoImport
  
  #Gad_Hide_All_Begin
  
  #Gad_MessageList_Hide_Begin
  #Gad_MessageList
  #Gad_MessageList_Hide_End
  
  #Gad_Welcome_Hide_Begin  
  #Gad_Welcome_AMS_Text
  #Gad_Welcome_WelcomeText
  #Gad_Welcome_AMS_Type
  #Gad_Welcome_ClientName_Text
  #Gad_Welcome_ClientName
  #Gad_Welcome_ClientLocation
  #Gad_Welcome_TroikaLogo
  #Gad_Welcome_Site_List
  
  #Gad_Welcome_Location
  #Gad_Welcome_Country
  #Gad_Welcome_Contact_Name
  #Gad_Welcome_ContactEmail
  #Gad_Welcome_Contact_Number
  #Gad_Welcome_Group_Count
  #Gad_Welcome_Roll_Count
  #Gad_Welcome_Rolls_Profiled14Days
  #Gad_Welcome_Rolls_Profiled6Weeks
  #Gad_Welcome_Rolls_Profiled6Months
  #Gad_Welcome_Rolls_Not_Profiled
  
  #Gad_Welcome_Location_Text
  #Gad_Welcome_Country_Text
  #Gad_Welcome_Contact_Name_Text
  #Gad_Welcome_ContactEmail_Text
  #Gad_Welcome_Contact_Number_Text
  #Gad_Welcome_Group_Count_Text
  #Gad_Welcome_Roll_Count_Text
  #Gad_Welcome_Rolls_Profiled14Days_Text
  #Gad_Welcome_Rolls_Profiled6Weeks_Text
  #Gad_Welcome_Rolls_Profiled6Months_Text
  #Gad_Welcome_Rolls_Not_Profiled_Text
  #Gad_Welcome_BorderRolls
  
  #Gad_Welcome_Hide_End
  
  ;/ **** Reporting ****
  #Gad_Report_Hide_Begin
  
  #Gad_Report_Counts_Text
  
  #Gad_Report_Preset_Combo
  #Gad_Report_Preset_Combo_Text
  #Gad_Report_Format_Checkbox
  #Gad_Report_SortBy_Combo
  #Gad_Report_SortBy_Combo_Text
  #Gad_Report_SortDirection_Text
  #Gad_Report_SortDirection_Combo
  #Gad_Report_Style_Combo
  #Gad_Report_Style_Text
  #Gad_Report_Filter_Frame
  #Gad_Report_Preset_Frame
  #Gad_Report_Site_Text
  #Gad_Report_Site_Combo
  #Gad_Report_Manufacturer_Text
  #Gad_Report_Manufacturer_Combo
  #Gad_Report_Suitability_Text
  #Gad_Report_Suitability_Combo
  #Gad_Report_Screen_Text
  #Gad_Report_Screen_From
  #Gad_Report_Screen_To_Text
  #Gad_Report_Screen_To
  #Gad_Report_Volume_Text
  #Gad_Report_Volume_From
  #Gad_Report_Volume_To_Text
  #Gad_Report_Volume_To
  #Gad_Report_Capacity_Text
  #Gad_Report_Capacity_From
  #Gad_Report_Capacity_To_Text
  #Gad_Report_Capacity_To
  #Gad_Report_Variance_Text
  #Gad_Report_Variance_From
  #Gad_Report_Variance_To_Text
  #Gad_Report_Variance_To
  
  #Gad_Report_Clear
  #Gad_Report_New
  #Gad_Report_Edit
  #Gad_Report_Delete
  
  #Gad_Report_ReportList
  
  #Gad_Report_ExportPDF
  #Gad_Report_ExportXLS
  #Gad_Report_ExportCSV
  
  #Gad_Report_Hide_End
  ;/ ********************
  
  #Gad_RollList_Hide_Begin
  #Gad_RollList_List
  #Gad_RollList_Hide_End
  
  #Gad_RollInfo_Hide_Begin
  #Gad_RollInfo_Start ;/ Encapsulation for easier event pickup
  #Gad_RollInfo_List ;/ Rollid / Manufacturer / Date Made / Group / Suitability.
  
  #Gad_Rollinfo_RollID_Text
  #Gad_Rollinfo_RollID_String
  #Gad_Rollinfo_Manufacturer_Text
  #Gad_Rollinfo_Manufacturer_String
  #Gad_Rollinfo_DateMade_Text
  #Gad_Rollinfo_DateMade_Date 
  #Gad_Rollinfo_Group_Text
  #Gad_Rollinfo_Group_Combo
  #Gad_Rollinfo_Suitability_Text
  #Gad_Rollinfo_Suitability_String
  
  #Gad_RollInfo_TroikaImage

  #Gad_RollInfo_Screen_Image
  #Gad_RollInfo_Screen_IDText
  #Gad_RollInfo_Screen_UnitText
  #Gad_RollInfo_Screen_String
  
  #Gad_RollInfo_Wall_Image
  #Gad_RollInfo_Wall_IDText
  #Gad_RollInfo_Wall_UnitText
  #Gad_RollInfo_Wall_String
  
  #Gad_RollInfo_Width_IDText
  #Gad_RollInfo_Width_UnitText
  #Gad_RollInfo_Width_String
  
  #Gad_Rollinfo_Readings_Text
  
  #Gad_RollInfo_Opening_Image
  #Gad_RollInfo_Opening_IDText
  #Gad_RollInfo_Opening_UnitText
  #Gad_RollInfo_Opening_String
  
  #Gad_RollInfo_Comment_Text
  #Gad_RollInfo_Comment_Box
  
  #Gad_RollInfo_GeneralHistory_Date_Text
  #Gad_RollInfo_GeneralHistory_Type_Text
  #Gad_RollInfo_GeneralHistory_Size_Text
  #Gad_RollInfo_GeneralHistory_Position_Text
  
  #Gad_RollInfo_GeneralHistory_History_Text
  #Gad_RollInfo_GeneralHistory_History_New
  #Gad_RollInfo_GeneralHistory_History_List
  
  #Gad_RollInfo_Image_Reference_Text
  #Gad_RollInfo_Image_Latest_Text
  #Gad_RollInfo_Image_Reference
  #Gad_RollInfo_Image_Latest
  
  #Gad_RollInfo_AniCAM_Image
  #Gad_RollInfo_Roll_Image
  #Gad_RollInfo_Roll_Pins
  
  #Gad_RollInfo_Vol1_Image
  #Gad_RollInfo_Vol2_Image
  #Gad_RollInfo_Vol3_Image
  #Gad_RollInfo_Vol4_Image
  #Gad_RollInfo_Vol5_Image
  
  #Gad_RollInfo_Import_Frame
  #Gad_RollInfo_Import_AMS
  #Gad_RollInfo_Import_ACP
  #Gad_RollInfo_Import_New ;/Manually input values
  #Gad_RollInfo_Delete 
  #Gad_RollInfo_Edit
  
  #Gad_RollInfo_Original_List
  #Gad_RollInfo_History_List
  
  #Gad_RollInfo_Original_Text
  #Gad_RollInfo_History_Text
  
  #Gad_Rollinfo_Update_Frame
  #Gad_Rollinfo_Update_Text
  #Gad_RollInfo_Commit
  #Gad_RollInfo_Undo
  
  #Gad_RollInfo_Finish ;/ encapsulation for easier event pickup
  #Gad_RollInfo_Hide_End
  
  #Gad_2D_Analysis_Hide_Begin
  #Gad_2D_Analysis_Image
  #Gad_2D_Analysis_Image_Mag
  #Gad_2D_Analysis_Hide_End
  
  #Gad_3D_Analysis_Hide_Begin
  #Gad_3D_Analysis_Image
  #Gad_3D_Analysis_Hide_End
  ;/ SQL Panel
  
  #Gad_SQL_Hide_Begin
  #Gad_SQL_Query_Txt
  #Gad_SQL_QueryUpdateCombo
  #Gad_SQL_Dropdown
  #Gad_SQL_Clear
  #Gad_SQL_Run
  #Gad_SQL_Set
  #Gad_SQL_Result_Txt
  #Gad_SQL_Hide_End
  
  #Gad_Hide_All_End
  
  ;/ ************* Settings Window Gadgets *************
  ;/ multi site only
  
  
  #Settings_Gad_SectionList
  #Settings_Gad_SectionList_Frame
  #Settings_Gad_SectionList_FrameText
  
  #Settings_Setting_Frame
  #Settings_Gad_Cancel
  #Settings_Gad_Okay
  
  #Settings_Gad_Hide_Start
  
  #Settings_Gad_Connection_Start
  #Settings_Gad_Connection_Frame
  #Settings_Gad_Connection_Name
  #Settings_Gad_Connection_Password
  #Settings_Gad_Connection_IP_Address
  #Settings_Gad_Connection_Required
  
  #Settings_Gad_Connection_Name_Text
  #Settings_Gad_Connection_Password_Text
  #Settings_Gad_Connection_IP_Address_Text
  #Settings_Gad_Connection_Required_Text
  #Settings_Gad_Connection_End
  ;/ Language & volume measurements (LPI / LPCM - CM3/M2 / BCM - 
  
  #Settings_Gad_Language_Start
  #Settings_Gad_Language_Frame
  #Settings_Gad_Language_Combo
  #Settings_Gad_Language_Combo_Text
  #Settings_Gad_Language_CSVDelimiter
  #Settings_Gad_Language_CSVDelimiter_Text
  #Settings_Gad_Language_DecimalNotation
  #Settings_Gad_Language_DecimalNotation_Text
  #Settings_Gad_Language_End
  
  #Settings_Gad_Import_Start
  #Settings_Gad_Import_AutoToggle
  #Settings_Gad_Import_Directory
  #Settings_Gad_Import_Directory_Text
  
  #Settings_Gad_Import_Database_Directory_Text
  #Settings_Gad_Import_Database_Directory
  
  #Settings_Gad_Import_DeleteAfter
  #Settings_Gad_Import_ShowReadingDepth
  #Settings_Gad_Import_End
  
  #Settings_Gad_Unit_Start
  #Settings_Gad_Unit_Frame
  #Settings_Gad_Unit_Screen_Combo
  #Settings_Gad_Unit_Length_Combo
  #Settings_Gad_Unit_Volume_Combo
  #Settings_Gad_Unit_Screen_Text
  #Settings_Gad_Unit_Length_Text
  #Settings_Gad_Unit_Volume_Text
  #Settings_Gad_Unit_End
  
  #Settings_Gad_DateFormat_Start
  #Settings_Gad_DateFormat_Frame
  #Settings_Gad_DateFormat_Text
  #Settings_Gad_DateFormat_Combo
  #Settings_Gad_DateFormat_End
  
  #Settings_Unit_Warnings_Start
  #Settings_Unit_Warnings_Frame
  #Settings_Unit_Warnings_Good_Text
  #Settings_Unit_Warnings_Okay_Text
  #Settings_Unit_Warnings_Bad_Text
  #Settings_Unit_Warnings_End
  
  #Settings_Unit_Warnings_Capacity_Start
  #Settings_Unit_Warnings_Capacity_Frame
  #Settings_Unit_Warnings_Capacity_Text
  #Settings_Unit_Warnings_Capacity_Good
  #Settings_Unit_Warnings_Capacity_Okay
  #Settings_Unit_Warnings_Capacity_Bad
  #Settings_Unit_Warnings_Capacity_End
  
  #Settings_Unit_Warnings_Variance_Start
  #Settings_Unit_Warnings_Variance_Frame
  #Settings_Unit_Warnings_Variance_Text
  #Settings_Unit_Warnings_Variance_Good
  #Settings_Unit_Warnings_Variance_Okay
  #Settings_Unit_Warnings_Variance_Bad
  #Settings_Unit_Warnings_Variance_End
  
  #Settings_Manufacturer_Start
  #Settings_Manufacturer_Frame
  #Settings_Manufacturer_List
  #Settings_Manufacturer_New
  #Settings_Manufacturer_Edit
  #Settings_Manufacturer_Delete
  #Settings_Manufacturer_End
  
  #Settings_Suitability_Start
  #Settings_Suitability_Frame
  #Settings_Suitability_List
  #Settings_Suitability_New
  #Settings_Suitability_Edit
  #Settings_Suitability_Delete
  #Settings_Suitability_End
  
  #Settings_MultiSite_Start
  #Settings_MultiSite_Frame
  #Settings_MultiSite_DatabasePath_Text
  #Settings_MultiSite_DatabasePath
  #Settings_MultiSite_DefaultSite
  #Settings_MultiSite_DefaultSite_Text
  #Settings_MultiSite_ShowDefaultOnly
  #Settings_MultiSite_PollingInterval
  #Settings_MultiSite_PollingInterval_Text
  #Settings_MultiSite_Seconds_Text
  
  #Settings_MultiSite_End
  
  #Settings_Gad_Hide_End
  
  #Gad_SiteInfo_Editor
  #Gad_SiteInfo_Okay
  
  #Gad_Code_Current_Text
  #Gad_Code_Current
  #Gad_Code_New_Text
  #Gad_Code_New_String
  #Gad_Code_Save
  #Gad_Code_Cancel
  #Gad_Code_Cur_Dec
  #Gad_Code_New_Dec

  #Gad_FullscreenImage
  
  #ManuFacturer_List
  #Suitability_List
  
  #AssignGroup_Okay
  #AssignGroup_Cancel
  #AssignGroup_Combo
  #AssignGroup_Text
    
  #Gad_GeneralHistory_Date
  #Gad_GeneralHistory_Type
  #Gad_GeneralHistory_Comments
  #Gad_GeneralHistory_Location
  #Gad_GeneralHistory_Okay
  #Gad_GeneralHistory_Cancel
  
  #Gad_GeneralHistory_Date_Text
  #Gad_GeneralHistory_Type_Text
  #Gad_GeneralHistory_Comments_Text
  #Gad_GeneralHistory_Location_Text
  
  #Gad_Reading_Date
  #Gad_Reading_Examiner
  #Gad_Reading_Vol1
  #Gad_Reading_Vol2
  #Gad_Reading_Vol3
  #Gad_Reading_Vol4
  #Gad_Reading_Vol5
  #Gad_Reading_Volume
;  #Gad_Reading_Quantity_Combo
  
  #Gad_Reading_Okay
  #Gad_Reading_Cancel
  
  #Gad_Reading_Date_Text
  #Gad_Reading_Examiner_Text
  #Gad_Reading_Vol1_Text
  #Gad_Reading_Vol2_Text
  #Gad_Reading_Vol3_Text
  #Gad_Reading_Vol4_Text
  #Gad_Reading_Vol5_Text
  #Gad_Reading_Volume_Text
  
  #Gad_Reading_Depth
  #Gad_Reading_Depth_Text
  
  #Gad_Reading_Quantity_Combo_Text
  
  #Gad_Presets_Name
  #Gad_Presets_Name_Text
  #Gad_Presets_Query
  #Gad_Presets_QueryCount
  #Gad_Presets_Query_Text
  #Gad_Presets_Save
  #Gad_Presets_Cancel
  #Gad_Presets_Test
  #Gad_Presets_RollTable
  
  #Gad_Presets_SuitabilityTable
  #Gad_Presets_ManufacturerTable
  #Gad_Presets_RollTable_Text
  #Gad_Presets_SuitabilityTable_Text
  #Gad_Presets_ManufacturerTable_Text
  
  #Gad_CSEdit_Location
  #Gad_CSEdit_Country
  #Gad_CSEdit_Name
  #Gad_CSEdit_Email
  #Gad_CSEdit_Number
  
  #Gad_CSEdit_Location_Text
  #Gad_CSEdit_Country_Text
  #Gad_CSEdit_Name_Text
  #Gad_CSEdit_Email_Text
  #Gad_CSEdit_Number_Text
  
  #Gad_CSEdit_Save
  #Gad_CSEdit_Cancel
  
  #Gad_Update_NewVersionText
  #Gad_Update_NewVersionEditorGadget
  #Gad_Update_NewVersionWeblink
  
  #Gad_EULA_Editor
  #Gad_EULA_IAcceptAgreement
  #Gad_EULA_IDonotAcceptAgreement
  #Gad_EULA_Cancel
  #Gad_EULA_Continue
  #Gad_EULA_LicenceAgreement_Text
  #Gad_EULA_DoYouAccept_Text
  #Gad_EULA_PleaseRead
  #Gad_EULA_TopBox
  #Gad_EULA_BottomSeperator
  #Gad_EULA_ContainerGadget

  #Gad_Password_String
  #Gad_Password_OK
  
EndEnumeration
Enumeration ;/Panels
  #Panel_HomeScreen = 1
  #Panel_Group_List
  #Panel_Roll_List
  #Panel_Roll_Info
  #Panel_2D_View
  #Panel_3d_View
  #Panel_Debug
  #Panel_SQL
EndEnumeration
Enumeration ;/Tree gadget data types
  #NavTree_Company
  #NavTree_Site
  #NavTree_Group
  #NavTree_Roll
EndEnumeration
Enumeration ;/Report Sort Fields
;  #Gad_Report_Sort_
  #Report_Sort_RollID
  #Report_Sort_Manufacturer
  #Report_Sort_Screen
  #Report_Sort_Volume
  #Report_Sort_Variance
  #Report_Sort_Capacity
  #Report_Sort_Suitability
  #Report_Sort_ReadingDate
EndEnumeration
Enumeration ;/Settings - Fields
  #Settings_Group_General
  #Settings_Field_Language
  #Settings_Field_DateFormat
  #Settings_Field_MeasurementsUnits
  #Settings_Field_LiveMonitoring
  #Settings_Group_WarningValues
  #Settings_Field_Variance_WarningValues
  #Settings_Field_Capacity_WarningValues
  #Settings_Group_DatabaseLists
  #Settings_Field_ManufacturerList
  #Settings_Field_SuitabilityTypes
  #Settings_Group_MultiSiteSettings
  #Settings_Field_MultiSiteSettings
EndEnumeration
Enumeration ;/Settings - DateFormat 
  #Settings_DateUnit_DDMMYYYY
  #Settings_DateUnit_MMDDYYYY
EndEnumeration
Enumeration ;/Settings - LineUnit 
  #Settings_ScreenUnit_LPI
  #Settings_ScreenUnit_LPCM
EndEnumeration
Enumeration ;/Settings - VolumeUnit 
  #Settings_VolumeUnit_CM3M2 = 0
  #Settings_VolumeUnit_BCM
EndEnumeration
Enumeration ;/Settings - LengthUnit 
  #Settings_LengthUnit_Micron
  #Settings_LengthUnit_Thou
EndEnumeration
Enumeration ;/Settings - Delimiter
  #Settings_Delimiter_Comma
  #Settings_Delimiter_Tab
EndEnumeration
Enumeration ;/Settings - Notation
  #Settings_Notation_Decimal
  #Settings_Notation_Comma
EndEnumeration
Enumeration ;/Databases
  #Databases_Master
  #Database_Reporting
  #Databases_NT_Site
  #Databases_NT_Group
  #Databases_NT_Roll
  #Databases_NT_Count
  #Databases_Language
  #Databases_LocalSettings
EndEnumeration
Enumeration ;/Database Readings
  #Reading_Master
  #Reading_Historical
EndEnumeration
Enumeration ;/Database Inserts
  #Database_Insert
  #Database_Overwrite
EndEnumeration
Enumeration ;/Database Colouring
  #Database_Colour_Good = 40960
  #Database_Colour_Okay = 36080
  #Database_Colour_Bad = 200
EndEnumeration
Enumeration ;/WindowColours
  #WinCol_HomeScreen = 16777215;14483455
  #WinCol_RollInfo = 16777200

  #WinCol_2d3dDebug = 16777215
  #WinCol_Report = 15794160

EndEnumeration
Enumeration ;/Listicon Justification Methods
  #PB_ListIcon_JustifyColumnLeft
  #PB_ListIcon_JustifyColumnCenter
  #PB_ListIcon_JustifyColumnRight
EndEnumeration
Enumeration ;/SSIDL Directory values
  #CSIDL_DESKTOP = $0                 ;{desktop}
  #CSIDL_INTERNET = $1                ;Internet Explorer (icon on desktop)
  #CSIDL_PROGRAMS = $2                ;Start Menu\Programs
  #CSIDL_CONTROLS = $3                ;My Computer\Control Panel
  #CSIDL_PRINTERS = $4                ;My Computer\Printers
  #CSIDL_PERSONAL = $5                ;My Documents
  #CSIDL_FAVORITES = $6               ;{user}\Favourites
  #CSIDL_STARTUP = $7                 ;Start Menu\Programs\Startup
  #CSIDL_RECENT = $8                  ;{user}\Recent
  #CSIDL_SENDTO = $9                  ;{user}\SendTo
  #CSIDL_BITBUCKET = $A               ;{desktop}\Recycle Bin
  #CSIDL_STARTMENU = $B               ;{user}\Start Menu
  #CSIDL_DESKTOPDIRECTORY = $10       ;{user}\Desktop
  #CSIDL_DRIVES = $11                 ;My Computer
  #CSIDL_NETWORK = $12                ;Network Neighbourhood
  #CSIDL_NETHOOD = $13                ;{user}\nethood
  #CSIDL_FONTS = $14                  ;windows\fonts
  #CSIDL_TEMPLATES = $15
  #CSIDL_COMMON_STARTMENU = $16       ;All Users\Start Menu
  #CSIDL_COMMON_PROGRAMS = $17        ;All Users\Programs
  #CSIDL_COMMON_STARTUP = $18         ;All Users\Startup
  #CSIDL_COMMON_DESKTOPDIRECTORY = $19;All Users\Desktop
  #CSIDL_APPDATA = $1A                ;{user}\Application Data
  #CSIDL_PRINTHOOD = $1B              ;{user}\PrintHood
  #CSIDL_LOCAL_APPDATA = $1C          ;{user}\Local Settings\Application Data (non roaming)
  #CSIDL_ALTSTARTUP = $1D             ;non localized startup
  #CSIDL_COMMON_ALTSTARTUP = $1E      ;non localized common startup
  #CSIDL_COMMON_FAVORITES = $1F
  #CSIDL_INTERNET_CACHE = $20
  #CSIDL_COOKIES = $21
  #CSIDL_HISTORY = $22
  #CSIDL_COMMON_APPDATA = $23          ;All Users\Application Data
  #CSIDL_WINDOWS = $24                 ;GetWindowsDirectory()
  #CSIDL_SYSTEM = $25                  ;GetSystemDirectory()
  #CSIDL_PROGRAM_FILES = $26           ;C:\Program Files
  #CSIDL_MYPICTURES = $27              ;C:\Program Files\My Pictures
  #CSIDL_PROFILE = $28                 ;USERPROFILE
  #CSIDL_SYSTEMX86 = $29               ;x86 system directory on RISC
  #CSIDL_PROGRAM_FILESX86 = $2A        ;x86 C:\Program Files on RISC
  #CSIDL_PROGRAM_FILES_COMMON = $2B    ;C:\Program Files\Common
  #CSIDL_PROGRAM_FILES_COMMONX86 = $2C ;x86 Program Files\Common on RISC
  #CSIDL_COMMON_TEMPLATES = $2D        ;All Users\Templates
  #CSIDL_COMMON_DOCUMENTS = $2E        ;All Users\Documents
  #CSIDL_COMMON_ADMINTOOLS = $2F       ;All Users\Start Menu\Programs\Administrative Tools
  #CSIDL_ADMINTOOLS = $30              ;{user}\Start Menu\Programs\Administrative Tools
  #CSIDL_FLAG_CREATE = $8000          ;combine with CSIDL_ value to force
  ;create on SHGetSpecialFolderLocation()
  #CSIDL_FLAG_DONT_VERIFY = $4000      ;combine with CSIDL_ value to force
  ;create on SHGetSpecialFolderLocation()
  #CSIDL_FLAG_MASK = $FF00             ;mask for all possible flag values
  #SHGFP_TYPE_CURRENT = $0             ;current value for user, verify it exists
  #SHGFP_TYPE_DEFAULT = $1
EndEnumeration

;/ Define structures

Structure ScaleGadget
  Gadget.i
  KeyPosX.i
  KeyPosY.i
  KeySizeX.i
  KeySizeY.i
  ScaleX.i
  ScaleY.i
  ScalePosX.i
  ScalePosY.i
  Minx.i
  Maxx.i
  Miny.i
  Maxy.i
  KeepRatio.i
  ColumnCount.i
  ColumnSize.i[64]
  FontID.i
EndStructure
Structure WinScale
  Windim.i
  WinXMin.i
  WinYMin.i
EndStructure
Structure Database_Company_Data
  Company_Name.S
  Company_Location.S
  Company_Country.S
  Company_Date_Issued.i
  
  Company_ExpansionI1.i
  Company_ExpansionI2.i
  Company_ExpansionI3.i
  Company_ExpansionI4.i
  Company_ExpansionI5.i
  
  Company_ExpansionS1.S
  Company_ExpansionS2.S
  Company_ExpansionS3.S
  Company_ExpansionS4.S
  Company_ExpansionS5.S
  
EndStructure
Structure Database_User_Data
  User_Name.S
  User_Password.S
  User_Company.S
  User_Priveliges.i
  
  User_Creation_Date.i
  User_Amended_Date.i
  
  User_ExpansionI1.i
  User_ExpansionI2.i
  User_ExpansionI3.i
  User_ExpansionI4.i
  User_ExpansionI5.i
  
  User_ExpansionS1.S
  User_ExpansionS2.S
  User_ExpansionS3.S
  User_ExpansionS4.S
  User_ExpansionS5.S
EndStructure
Structure Database_AniCAM_Reading
  
EndStructure
Structure AMSFile
  Header.S ;/1
  CustomerID.S ;/2
  RollID.S ;/3
  Operator.S ;/4
  DateStamp.S ;/5  Includes time
  Day.i : Month.i : Year.i : DateNum.i
  SamplesUsed.S ;/ always 8?? ;/6
  MaxSamples.S ;/ ?? Sometimes the volume (Avg mode??) ;/7
  Sample1.S ;/ 8 ??
  Sample2.S ;/ 9 ??
  Sample3.S ;/ 10 ??
  Sample4.S ;/ 11 ??
  Sample5.S ;/ 12 ??
  Sample6.S ;/ 13 ??
  Sample7.S ;/ 14 ??
  Sample8.S ;/ 15 ?? Sometimes the volume (Avg mode?)
  Volume.S ;/ 16
  Depth.S ;/ 17
  CellOpening.S ;/ 18
  CellWall.S ;/ 19
  RollScreenCount.S ;/ 20
  RollAngle.S ;/ 21
  AniCAM_Config.S ;/ 22
  SavedImagePath.S ;/ 23
  DateFormat.i ;/ 
  VolumeUnit.i ;/ 
  ScreenUnit.i
  MeasurementUnit.i ;/
  PPM.f ;/
EndStructure
Structure SystemVariables
  Showing_Panel.i
  Showing_RollID.i
  
  Window_Main_Events.i
  Desktop_Width.i
  Desktop_Height.i

  Selected_Site.i
  Selected_Group.i
  Selected_Roll_ID.i
  Selected_Roll_Info.i
  Selected_HistoryID.i
  
  Selected_Site_Text.S
  Selected_Group_Text.S
  Selected_Roll_ID_Text.S
  Selected_Roll_Info_Text.S
  ForceSelectRollID.i ;/ for when refreshing NavTree
  
  Last_Drawn_Roll.l
  Last_Drawn_Report_SiteId.l
  Last_Drawn_Report_GroupId.l
  Last_Keyed_Operator.s
  
  Database_User_Count.i
  Database_Site_Count.i
  Database_Group_Count.i
  Database_Roll_Count.i
  Database_RollInfo_Count.i
  Database_Company.S
  
  Database_Version.i 
  
  TV_Line.i ;/ TreeGadget
  TV_Depth.i

  Settings_Language.s
  Settings_User_Name.S
  Settings_User_Password.S
  Settings_IP_Address.S
  Settings_Connection_Required.S
  Settings_Connected.i
  Settings_Date_Format.i
  Settings_Date_Mask.S
  
  Settings_Screen_Unit.i  ;/ LPI - LPCM
  Settings_Screen_UnitString.S 
  Settings_Screen_UnitMask.S
  
  Settings_Volume_Unit.i ;/ CM3/M2
  Settings_Volume_UnitMask.S
  Settings_Volume_UnitString.S
  
  Settings_Length_Unit.i ;/ Microns / Thou
  Settings_Length_UnitMask.S ;/
  Settings_MLength_UnitMask.S ;/ Cm / In
  Settings_Length_UnitString.S ;/
  
  Settings_SiteLimit.i
  Settings_RollLimit.i
  Settings_ReadingsLimit.i
  Settings_Variance_Good.i
  Settings_Variance_Bad.i
  Settings_Capacity_Good.i
  Settings_Capacity_Bad.i

  SQL_Previous_Text.S
  
  User_Name.S
  User_Site.i
  User_AccessLevel.i
  
  ;/ Refresh required Variables
  Refresh_NavTreeID.i
  Refresh_NavTree_Type.i
  Refresh_Roll_List.i
  Refresh_Roll_Information.i
  
  Quit.i
  
  CurrentSearchPos.i
  
  Image2d_RollID.i
  Image3d_RollID.i
  
  Zoom_2d.i
  
  Drag_Selected.l
  Drag_Target.l
  
  Editted.i
  ReportLines_Total.i
  ReportLines_Filtered.i
  Report_Type.i ;/ Flat 1 or Grouped 0
  
  *ImageMemory
  
  ImportPath.s
  
  *ReferenceImage
  Reference_Image_Length.i
  
  *CurrentImage
  Current_Image_Length.i
  
  DatabaseHandle.l
  DatabaseWrites.i
  LiveMonitor.i
  LiveMonitorNextTime.i
  WindowMinimized.i
  LastImportedFile.s ;/ Has the CRC of the AMS file + the Timestamp, to control the auto importing routine not continually failing on a bad AMS file.
  DeleteAfterImport.i
  TimeTest.i
  Language_Update.i
  LastSelectedGadget.i
  
  Font_Name.s
  Font_Size_XS.i
  Font_Size_S.i
  Font_Size_M.i
  Font_Size_L.i
  Font_Size_XL.i
  
  DecimalNotation.i
  CSVDelimiter.i
  
  Language_Current_Element.i
  Language_Current_File.s
  
  Manager_Mode.i
  
  Show_Depth.i
  ;/ new variables for Multi-Site
    
  Database_Path.s
  Default_Site.i
  PollingInterval.i
  DefaultOnly.i
  
  Next_Poll_Check.i
  TimeStamp_Main.i
  TimeStamp_Site.i
  TimeStamp_Group.i
  TimeStamp_Roll.i
  
  Weblink.s
  OEMLogo.s
  
  Last_Image_Import_Directory.s
  
EndStructure
Structure SQL_Queries
  Line_Count.i
  Title.S
  Line.S[20]
EndStructure
Structure Tree
  Type.i ; 0 = Home, 1 = Site, 2 = Group, 3 = Roll
  String.S ;/ String to display
  AddString.S ;/ String for additional info on main string
  RollID.i
;  Level.i ;/ level in treegadget
  SiteID.i
  GroupID.i
;  Position.i
EndStructure
Structure Group
  Name.S
  ID.i  
EndStructure
Structure ID_Name
  ID.i
  Text.S
  Count.i
  TimeStamp.i
EndStructure
Structure RollInformation
  RollID.s
  Manufacturer.i
  DateMade.i
  Group.i
  Suitability.i
  Screen.s
  WallWidth.s
  CellOpening.s
  RollWidth.s
  Comments.s
  Depth.i
EndStructure
Structure Report_Preset
  ID.i
  Name.s
  SQL.s
EndStructure
Structure ReportFlat
  RollID.s
  Group.s
  Manufacturer.s
  Screen.s
  Volume.s
  Variance.s
  Capacity.s
  Suitability.s
  Last_Profiled.s
EndStructure
Structure NOTIFYICONDATA_v6
  cbSize.l
  hWnd.l
  uID.l
  uFlags.l
  uCallbackMessage.l
  hIcon.l
  szTip.s{128}
  dwState.l
  dwStateMask.l
  szInfo.s{256}
  StructureUnion
    uTimeout.l
    uVersion.l
  EndStructureUnion
  szInfoTitle.s{64}
  dwInfoFlags.l
  guidItem.GUID
EndStructure
Structure LanguageMaster
  FileName.s
  Language.s
  FontName.s
  FontsizeXS.i
  FontsizeS.i
  FontsizeM.i
  FontsizeL.i
  FontsizeL_Bold.i
  FontsizeXL.i
  Comment.s
  StringCount.i
  String.s[400]
  String_Override.s[400]
  CSVDelimiter.i
  DecimalNotation.i
EndStructure
Structure HW_PROFILE_INFO
  DockInfo.l
  szHWProfileGUID.c[#HW_PROFILE_GUIDLEN]
  szHwProfileName.c[#MAX_PROFILE_LEN]
EndStructure
Structure NavEntry
  ID.i
  Name.s
  Parent.i
  Count.i
EndStructure

;/ Global declarations.... 
Global NewList Sites.NavEntry()
Global NewList Groups.NavEntry()
Global NewList Rolls.NavEntry()
Global DatabaseFile.S, LocalSettingsDB.s, LanguagesDirectory.s

Global event.i, gad.i, X.i, Y.i, *ImMem, SQL.s
Global NewList GadgetScale.ScaleGadget()
Global NewList GroupList.Group()

Global WinInfo.WinScale
Global DefaultComboBoxCallback.i

Global System.SystemVariables
Global RollInfo.RollInformation
Global AMS_Import.AMSFile
Global NewList My_SQL_Queries.SQL_Queries()
Global NewList NavTree.Tree()
Global NewList DamageList.i() ;/ Holds the Damage listview to Database DamageID reference (For editting & Deleting)
Global NewList HistoryList.i() ;/ Holds the historical listview readings to Database Roll_Data ID (For editting and deleting)
Global NewList SuitabilityList.ID_Name() ;/ Holds the list of suitability texts (read from database)
Global NewList ManufacturerList.ID_Name() ;/ Holds the list of Manufacturers texts (read from database)
Global NewList LanguageList.ID_Name() ;/ Holds the list of Languages (read from database)
Global NewList SiteList.ID_Name() ;/ Holds the sitelist

Global NewList Database_GroupList.ID_Name() ;/ Holds the database groups, used during Roll Information windows
Global NewList ReportLine_RollID.i()
Global NewList Report_PresetList.Report_Preset()  
Global NewList Report_FlatList.s()
Global NewList LangMaster.Languagemaster()

System\ImportPath = "C:\ExportAMS\" ;/DNT
;}

;/ Declarations for out-of-sequence procedures
Declare.i Database_CountQuery(SQL.S, LineNum.i, Quiet.i = 0)
Declare.S Database_StringQuery(SQL.S, Database.i = #Databases_Master)
Declare Redraw_Navtree()

Procedure.s GetSpecialFolder(iVal.l)
  ;/ Procedure that returns the 'All User' data storage area
  ;/ Win XP - C:\Documents&Settings\AllUsers\ProgramData
  ;/ Windows Vista & 7;  C:\ProgramData\AllUsers\
  
  Protected Folder_ID, SpecialFolderLocation.s
  
  If SHGetSpecialFolderLocation_(0, iVal, @Folder_ID) = 0
    
    SpecialFolderLocation = Space(#MAX_PATH)
    SHGetPathFromIDList_(Folder_ID, @SpecialFolderLocation)
    
    If SpecialFolderLocation
      
      If Right(SpecialFolderLocation, 1) <> "\"
        
        SpecialFolderLocation + "\"
        
      EndIf
      
    EndIf
    
    CoTaskMemFree_(Folder_ID)
    
  EndIf
  
  ProcedureReturn SpecialFolderLocation
  
EndProcedure

;Debug "*** All Users Appdata?: "+GetSpecialFolder($23)
DatabaseFile = GetSpecialFolder($23)+"Troika Systems\AMS\AMS_SS.DB" ;/DNT
LocalSettingsDB.s = GetSpecialFolder($23)+"Troika Systems\AMS\LocalSettings.DB"
LanguagesDirectory = GetSpecialFolder($23)+"Troika Systems\AMS\Languages\"

Macro Debug(Txt)
  Debug FormatDate("%hh:%ii:%ss", Date())  + Txt  ;/DNT
EndMacro
Macro GetGadgetTextMac(a)
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when retrieving.
  ReplaceString(ReplaceString(GetGadgetText(a),"''","'"),"'","''") ;/DNT
EndMacro
Procedure.s FormatTextMac(a.s) 
  ;/ a macro to force string encapsulation of ' character, otherwise text issues will ensue when storing.
  ProcedureReturn ReplaceString(ReplaceString(a,"''","'"),"'","''") ;/DNT
EndProcedure

Procedure SetListIconColumnJustification(ListIconID, Column, Alignment)
  ;/ WinAPI Procedure to set column justifications, PH requested certain columns would look better if centre justified. 
  Protected ListIconColumn.LV_COLUMN
  
  ListIconColumn\mask = #LVCF_FMT
  
  Select Alignment
    Case #PB_ListIcon_JustifyColumnLeft
      ListIconColumn\fmt = #LVCFMT_LEFT
    Case #PB_ListIcon_JustifyColumnCenter
      ListIconColumn\fmt = #LVCFMT_CENTER
    Case #PB_ListIcon_JustifyColumnRight
      ListIconColumn\fmt = #LVCFMT_RIGHT
  EndSelect
  
  SendMessage_(GadgetID(ListIconID), #LVM_SETCOLUMN, Column, @ListIconColumn)
EndProcedure
Procedure.s StrfS(Num.f,Nul.i = 1)
  ;/ a procedure to transfer a float to a string, with either decimal or comma as the notation)
  
  Protected Txt.s
  Txt.s = StrF(Num.f,1)
  
  If System\Settings_Volume_Unit = 1 And Num < 10
    Txt.s = StrF(Num.f,2)
  EndIf
  
  If System\DecimalNotation = 1 ;/ 0 = decimal point, 1 = comma
    Txt = ReplaceString(Txt.s,".",",")
  EndIf
  
  ProcedureReturn Txt
EndProcedure

Procedure.f ValfS(Txt.s)
  ;/ a procedure to transfer a string to a float, with either decimal or comma as the notation)
  Protected Num.f
  
  If System\DecimalNotation = 1 ;/ 0 = decimal point, 1 = comma
    Txt = ReplaceString(Txt.s,",",".")
  EndIf
  Num = ValF(Txt.S)

  ProcedureReturn Num
EndProcedure
Procedure Message_Add(Text.S)
  ;/ Procedure to add to the internal message list, can be handy for debugging.
;  If #Debug = 0 : ProcedureReturn  : EndIf
  If IsGadget(#Gad_MessageList) : AddGadgetItem(#Gad_MessageList,-1,Text) : EndIf 
EndProcedure

Procedure.s HardwareFingerprint()
  ;/ ***************************************************************************************************************
  ;/ Produces a unique computer ID fingerprint, this is stored in the EULA agreement table upon agreement.
  ;/ ***************************************************************************************************************
  ;/ In:  Null
  ;/ Out: Hardware fingerprint as a string
  ;/ ***************************************************************************************************************
  
  Protected hwp.HW_PROFILE_INFO
  GetCurrentHwProfile_(@hwp)
  Debug PeekS(@hwp\szHwProfileName[0]) + " -> " + PeekS(@hwp\szHWProfileGUID[0])
  ProcedureReturn PeekS(@hwp\szHWProfileGUID[0])
EndProcedure

;/ SQLite (Single_Site) Procedures

Procedure Database_Update(Database, query.S,LineNum.i)
  ;/ ***************************************************************************************************************
  ;/ This procedure is used for all database updates, user is warned if error occurs.  Message is added to the message
  ;/ list with the query text and the time it has taken to run.
  ;/ ***************************************************************************************************************
  ;/ In:  Database ID, Query String, source linenumber that update was called from.
  ;/ Out: Result (Integer) - is update acknowledgement, or zero if update error.
  ;/ ***************************************************************************************************************
  
  If IsDatabase(Database)
    
    Protected Result.i, Time.i
    time = ElapsedMilliseconds()-time
    Debug query
    Result = DatabaseUpdate(Database, query.s)

    If Result = 0
      MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" ",query+Chr(10)+DatabaseError())
    EndIf
    time = ElapsedMilliseconds()-time
    Message_Add("DU: "+query+ " - "+Str(time)+"ms - LN:"+Str(LineNum))
    
    ProcedureReturn Result
  Else
    Message_Add("Database call error from Line: "+Str(LineNum)+" - Database: "+Str(Database)+" not open")
  EndIf
  
  
EndProcedure
Procedure.i Database_WriteCheck()
  Protected Result.i
  Result = DatabaseUpdate(#Databases_Master, "Update AMS_Groups Set Type = 0 where ID = 1")
  If Result = 0 ;/ Was unable to update / write
    ProcedureReturn 0 
  EndIf
  ProcedureReturn 1
EndProcedure

Procedure.i Database_CountQuery(SQL.S, LineNum.i, Quiet.i = 0)
  ;/ This procedure is used for almost all database Count type queries, user is warned if error occurs.  Message is added to the message
  ;/  list with the query text and the time it has taken to run.
  
  Protected Result.i, QueryResult.i, Time.i
  
  time = ElapsedMilliseconds()-time
  
  QueryResult =  DatabaseQuery(#Databases_Master, SQL)
  NextDatabaseRow(#Databases_Master) ;/ only one row, so no need for while / 
  Result = Val(GetDatabaseString(#Databases_Master,0))
  
  If QueryResult = 0 And quiet = 0
    MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  FinishDatabaseQuery(#Databases_Master)
  
  time = ElapsedMilliseconds()-time
  Message_Add("DCQ: "+SQL+ " - "+Str(time)+"ms - LN:"+Str(LineNum))
  
  ProcedureReturn Result
EndProcedure
Procedure.S Database_StringQuery(SQL.S, Database.i = #Databases_Master)
    ;/ This procedure is used for almost all database Count type queries, user is warned if error occurs.  Message is added to the message
  ;/  list with the query text and the time it has taken to run.
  
  Protected Result.S, QueryResult.i, Time.i
  
  time = ElapsedMilliseconds()-time
  
  QueryResult = DatabaseQuery(Database, SQL)
  NextDatabaseRow(Database) ;/ only one row, so no need for while / 
  Result = GetDatabaseString(Database,0)
  
  If QueryResult = 0
    MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  
  FinishDatabaseQuery(Database)
  
  time = ElapsedMilliseconds()-time
  Message_Add("DSQ: "+SQL+ " - "+Str(time)+"ms")
  
  ProcedureReturn Result.S
EndProcedure
Procedure.i Database_IntQuery(SQL.S, Database.i = #Databases_Master)
  Protected Result.i, QueryResult.i, Time.i
  
  time = ElapsedMilliseconds()-time
  
  QueryResult = DatabaseQuery(Database, SQL)
  NextDatabaseRow(Database) ;/ only one row, so no need for while / 
  Result = GetDatabaseLong(Database,0)
  
  If QueryResult = 0
    MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" ",SQL+Chr(10)+DatabaseError())
  EndIf
  
  FinishDatabaseQuery(Database)
  
  time = ElapsedMilliseconds()-time
  Message_Add("DIQ: "+SQL+ " - "+Str(time)+"ms")
  
  ProcedureReturn Result.i
EndProcedure
Procedure.f Database_FloatQuery(SQL.S,LineNum.i)
  Protected Result.f, QueryResult.i, Time.i
  
  time = ElapsedMilliseconds()-time
  
  QueryResult = DatabaseQuery(#Databases_Master, SQL)
  NextDatabaseRow(#Databases_Master) ;/ only one row, so no need for while / 
  Result = GetDatabaseFloat(#Databases_Master,0)
  
  If QueryResult = 0
    MessageRequester("Error with SQL? ", SQL+Chr(10)+DatabaseError())  ;/DNT
  EndIf
  
  FinishDatabaseQuery(#Databases_Master)
  
  time = ElapsedMilliseconds()-time
  Message_Add("DFQ: "+SQL+ " - "+Str(time)+"ms - LN:"+Str(LineNum))
  
  ProcedureReturn Result.f

EndProcedure
Procedure.i Database_SetMainTimeStamp()

    Debug "*******************************************"
    Debug "*** Updating Main timestamp ***"
    Debug "*******************************************"

  Database_Update(#Databases_Master,"Update AMS_Settings Set TimeStamp = "+Str(Date()),#PB_Compiler_Line)
EndProcedure
Procedure.i Database_SetSiteTimeStamp(Site.i)
  If Site > 0
    Debug "*******************************************"
    Debug "*** Updating Site timestamp ***"
    Debug "*******************************************"
    Database_Update(#Databases_Master,"Update AMS_Sites Set TimeStamp = "+Str(Date())+" where ID = "+Str(Site)+";",#PB_Compiler_Line)
    Database_SetMainTimeStamp()
  EndIf
EndProcedure
Procedure.i Database_SetGroupTimeStamp(Group.i)
  Protected SiteID.i
  If Group > 0
    Debug "*******************************************"
    Debug "*** Updating Group timestamp ***"
    Debug "*******************************************"
    SiteID = Database_IntQuery("Select SiteID From AMS_groups Where ID = "+Str(Group)+";")
    Database_Update(#Databases_Master,"Update AMS_Groups Set TimeStamp = "+Str(Date())+" where ID = "+Str(Group)+";",#PB_Compiler_Line)
    If SiteID > 0
      Database_SetSiteTimeStamp(SiteID)
    EndIf
  EndIf
EndProcedure
Procedure.i Database_SetRollTimeStamp(Roll.i)
  Protected GroupID.i
  
  If Roll > 0
    Debug "*******************************************"
    Debug "*** Updating Roll timestamp ***"
    Debug "*******************************************"
    GroupID = Database_IntQuery("Select GroupID From AMS_Roll_Master Where ID = "+Str(Roll)+";")
    Database_Update(#Databases_Master,"Update AMS_Roll_Master Set TimeStamp = "+Str(Date())+" where ID = "+Str(Roll)+";",#PB_Compiler_Line)
    If GroupID > 0
      Database_SetGroupTimeStamp(GroupID)
    EndIf
  EndIf
EndProcedure
Procedure.i Database_GetMainTimeStamp()
  ProcedureReturn Database_IntQuery("Select TimeStamp from AMS_Settings")
EndProcedure
Procedure.i Database_GetSiteTimeStamp(Site.i)
  ProcedureReturn Database_IntQuery("Select TimeStamp from AMS_Sites Where ID = "+Str(Site)+";")
EndProcedure
Procedure.i Database_GetGroupTimeStamp(Group.i)
  ProcedureReturn Database_IntQuery("Select TimeStamp from AMS_Groups Where ID = "+Str(Group)+";")
EndProcedure
Procedure.i Database_GetRollTimeStamp(Roll.i)
  ProcedureReturn Database_IntQuery("Select TimeStamp from AMS_Roll_Master Where ID = "+Str(Roll)+";")
EndProcedure
Procedure SQLite_Process_Live_Update()
  Protected MyLoop.i, MyDBLoop.i, SQL.S, Txt.S, Add_Txt.S, Columns.i, Difference.i
  Debug "Running live UPDATE"
  ;/ Check for differences
  Txt = "" : Difference = 0
  For MyLoop = 0 To CountGadgetItems(#Gad_SQL_Query_Txt)
    Txt + Trim(GetGadgetItemText(#Gad_SQL_Query_Txt,MyLoop))
  Next
  
  If Txt = System\SQL_Previous_Text : ProcedureReturn : EndIf ;/ only run queries if changes have occurred

  System\SQL_Previous_Text = Txt ;/ set new query text as our current text
  
  For MyLoop = 1 To 100
    RemoveGadgetColumn(#Gad_SQL_Result_Txt,0)
  Next
  ClearGadgetItems(#Gad_SQL_Result_Txt)
  AddGadgetColumn(#Gad_SQL_Result_Txt,0,"Update Results",500)
  For MyLoop = 0 To CountGadgetItems(#Gad_SQL_Query_Txt)
    Txt = GetGadgetItemText(#Gad_SQL_Query_Txt,MyLoop)
    SQL + Txt : Txt = ""
  Next
  
  AddGadgetItem(#Gad_SQL_Result_Txt,-1,"Update Result: "+Str(Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)))
  Redraw_NavTree()
EndProcedure
Procedure SQLite_Process_Live_Query()
  Protected MyLoop.i, MyDBLoop.i, SQL.S, Txt.S, Add_Txt.S, Columns.i, Difference.i
  Debug "Running live query"
  ;/ Check for differences
  Txt = "" : Difference = 0
  For MyLoop = 0 To CountGadgetItems(#Gad_SQL_Query_Txt)
    Txt + Trim(GetGadgetItemText(#Gad_SQL_Query_Txt,MyLoop))
  Next
  
  If Txt = System\SQL_Previous_Text : ProcedureReturn : EndIf ;/ only run queries if changes have occurred

  System\SQL_Previous_Text = Txt ;/ set new query text as our current text
  
  For MyLoop = 1 To 100
    RemoveGadgetColumn(#Gad_SQL_Result_Txt,0)
  Next
  ClearGadgetItems(#Gad_SQL_Result_Txt)
  
  For MyLoop = 0 To CountGadgetItems(#Gad_SQL_Query_Txt)
    Txt = GetGadgetItemText(#Gad_SQL_Query_Txt,MyLoop)
    SQL + Txt : Txt = ""
    
    If FindString(SQL,";",1)
      If DatabaseQuery(#Databases_Master, SQL)
        Columns = DatabaseColumns(#Databases_Master)-1
        For MyDBLoop = 0 To Columns
          AddGadgetColumn(#Gad_SQL_Result_Txt,MyDBLoop,Str(MyDBLoop)+":"+DatabaseColumnName(#Databases_Master,MyDBLoop),100)
        Next 
        
        While NextDatabaseRow(#Databases_Master)
          For MyDBLoop = 0 To Columns
            Add_Txt = GetDatabaseString(#Databases_Master, MyDBLoop)
            Txt + Add_Txt+Chr(10)
          Next
          AddGadgetItem(#Gad_SQL_Result_Txt,-1,Txt) : Txt = "" : SQL = ""
        Wend
        FinishDatabaseQuery(#Databases_Master)
      Else
        Debug "Failed to run query..."
      EndIf
    EndIf
  Next
EndProcedure
Procedure Database_Process_PopulateCurrentDepths()
  Protected SQL.s, Depth.i, Update.i
  NewList RollIDs.ID_Name()
  
  ;/ Read in initial RollIDs and depths
  DatabaseQuery(#Databases_Master,"Select ID, Depth from AMS_Roll_Master")
  While NextDatabaseRow(#Databases_Master)
    AddElement(RollIDs())
    RollIDs()\ID = GetDatabaseLong(#Databases_Master, 0)
    RollIDs()\Count = GetDatabaseLong(#Databases_Master, 1)
  Wend
  FinishDatabaseQuery(#Databases_Master)
  
  ;MessageRequester("Message:","Read in: "+Str(ListSize(RollIDs()))+" Roll records.")
  
  ;/ Now, for each rollID, run a query to get the latest depth
  ForEach RollIDs()
    DatabaseQuery(#Databases_Master,"Select Depth from AMS_Roll_Data where RollID = '"+Str(RollIDs()\ID) +"' Order by Readingdate Desc")
    NextDatabaseRow(#Databases_Master)
    Depth = GetDatabaseLong(#Databases_Master,0)
    
    If Depth > 0
      RollIDs()\Count = Depth
      Update + 1
    EndIf
    
    FinishDatabaseQuery(#Databases_Master)
  Next
  
  ;MessageRequester("Message:","Updated depths for: "+Str(Update)+" Rolls.")
  
  ;/ Now update all current depths with stored depths
  DatabaseUpdate(#Databases_Master,"BEGIN;")
  ForEach RollIDs()
    DatabaseUpdate(#Databases_Master,"Update AMS_Roll_Master Set Current_Depth = "+Str(RollIDs()\Count)+" Where ID = "+Str(RollIDs()\ID))
  Next
  DatabaseUpdate(#Databases_Master,"COMMIT;")
  ClearList(RollIDs())  
  
  ;/ 
EndProcedure

Procedure Database_CheckVersion()
  Protected Version.i, NewVersion.i, AddedText.s
  
  Version = Database_IntQuery("Select Version from AMS_Settings") ;/DNT
  NewVersion = Version
  AddedText = ""
  
  ;/ All Updates take place here
  
  If Version < 2 ; add Directory watch Toggle and Import Directory to settings table
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings ADD Monitor Int",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings ADD ImportPath Char",#PB_Compiler_Line) ;/DNT
    
    ;/ Set default parameters
    Database_Update(#Databases_Master,"Update AMS_Settings SET Monitor_Int = 0, ImportPath = 'C:\ExportAMS';",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 2: Added Monitor flag and ImportPath string"+Chr(10) ;/DNT
    NewVersion = 2
  EndIf
  
  If Version < 3 ; add Delete after import toggle
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings ADD Import_Delete",#PB_Compiler_Line) ;/DNT
    
    ;/ Set default parameters
    Database_Update(#Databases_Master,"Update AMS_Settings SET Import_Delete = 0;",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 3: Added Delete on import flag"+Chr(10) ;/DNT
    NewVersion = 3
  EndIf  
  
  If Version < 4 ; add Delete after import toggle
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings Drop Column Language",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings ADD [Language] Char",#PB_Compiler_Line) ;/DNT
    ;/ Set default parameters
    Database_Update(#Databases_Master,"Update AMS_Settings SET Language = 'English';",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 4: Changed data type for Language field"+Chr(10) ;/DNT
    NewVersion = 4
  EndIf  
  
  If Version < 5
    Database_Update(#Databases_Master,"Create TABLE [AMS_EULA_Agreements] ([HardwareInfo] Char, [SystemName] Char, [UserName] Char, [DateAgreed] Int);",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 5: New table (AMS_EULA_Agreements) inserted"+Chr(10) ;/DNT
    NewVersion = 5
  EndIf  
  
  If Version < 6 ;/ multi site changes
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Groups ADD Timestamp Int",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Sites ADD Timestamp Int",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Roll_Master ADD Timestamp Int",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings ADD Timestamp Int",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 6: Added Timestamps to AMS_Groups & AMS_Sites"+Chr(10) ;/DNT
    NewVersion = 6
  EndIf
  
  If Version < 7
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Roll_Data ADD AniCAM_Config Char",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Roll_Data ADD Depth Int",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Roll_Master ADD AniCAM_Config Char",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Roll_Master ADD Depth Int",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 7: Added AniCAM_Config and Depth fields to AMS_Roll_Master & AMS_Roll_Data" + Chr(10) ;/DNT
    NewVersion = 7
  EndIf 
  
  If Version < 8
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Settings ADD [Show_Depth] Int",#PB_Compiler_Line) ;/DNT
    Database_Update(#Databases_Master,"Update AMS_Settings SET Show_Depth = '1';",#PB_Compiler_Line) ;/DNT

    AddedText + "Version 8: Added Show_Depth field to AMS_Settings table." + Chr(10) ;/DNT
    NewVersion = 8
  EndIf
  
  If Version < 9
    Database_Update(#Databases_Master,"ALTER TABLE AMS_Roll_Master ADD Current_Depth Int",#PB_Compiler_Line) ;/DNT
    AddedText + "Version 9: Added Current_Depth field to AMS_Roll_Master table." + Chr(10) ;/DNT
    NewVersion = 9
    Database_Process_PopulateCurrentDepths()
  EndIf  
  
  If Version <> NewVersion
    Database_Update(#Databases_Master,"Update AMS_Settings Set Version = "+Str(NewVersion),#PB_Compiler_Line) ;/DNT
    MessageRequester("Message:","Database has been updated from version "+Str(Version) + " to version "+Str(NewVersion)+Chr(10)+Chr(10)+AddedText) ;/DNT
  EndIf
  
  If Multi_Site_Mode = 1
    Version = Database_IntQuery("Select Version from AMS_LocalSettings",#Databases_LocalSettings) ;/DNT
    ;/ check local settings here for Multi site only
    If Version < 6 ;/ multi site changes
      Database_Update(#Databases_LocalSettings,"ALTER TABLE AMS_LocalSettings ADD [Show_Depth] Int",#PB_Compiler_Line) ;/DNT
      Database_Update(#Databases_LocalSettings,"Update AMS_LocalSettings SET Show_Depth = '1';",#PB_Compiler_Line) ;/DNT
      
      AddedText + "Version 6: Added Show_Depth field to AMS_LocalSettings table." + Chr(10) ;/DNT
      NewVersion = 6
    EndIf
    If Version <> NewVersion
      Database_Update(#Databases_LocalSettings,"Update AMS_LocalSettings Set Version = "+Str(NewVersion),#PB_Compiler_Line) ;/DNT
      MessageRequester("Message:","Multi-Site Database has been updated from version "+Str(Version) + " to version "+Str(NewVersion)+Chr(10)+Chr(10)+AddedText) ;/DNT
    EndIf
  EndIf

EndProcedure
Procedure.s Get_Manufacturer_Text(Manufacturer.i=-1)
  If Manufacturer = -1
    ForEach ManufacturerList()
      If RollInfo\Manufacturer = ManufacturerList()\ID
        ProcedureReturn ManufacturerList()\Text
      EndIf
    Next

  Else
    ForEach ManufacturerList()
      If ManufacturerList()\ID = Manufacturer
        ProcedureReturn ManufacturerList()\Text
      EndIf
    Next
  EndIf
  
  ProcedureReturn ""
EndProcedure
Procedure.i Get_Manufacturer_Value(Manufacturer.s="")
  ;Debug "*** Manufacturer: "+Manufacturer
  If Manufacturer = ""
    ProcedureReturn RollInfo\Manufacturer
  Else
    ForEach ManufacturerList()
      If ManufacturerList()\Text = Manufacturer
  ;      Debug "*** Manufacturer ID: "+Str(ManufacturerList()\ID)
        ProcedureReturn ManufacturerList()\ID
      EndIf
    Next
  EndIf
  ProcedureReturn
EndProcedure
Procedure.i Get_Manufacturer_Index(Manufacturer.i = 0)
  If Manufacturer = 0
    ForEach ManufacturerList()
      If RollInfo\Manufacturer = ManufacturerList()\ID
        ProcedureReturn ManufacturerList()\Count
      EndIf
    Next
  Else
    ForEach ManufacturerList()
      If ManufacturerList()\ID = Manufacturer
        ProcedureReturn ManufacturerList()\Count
      EndIf
    Next
  EndIf
  ProcedureReturn
EndProcedure

Procedure.s Get_Suitability_Text(Suitability.i=-1) 
  ;/ if zero is passed in, returns text of currently selected roll
  If Suitability = -1
    ForEach SuitabilityList()
      If RollInfo\Suitability = SuitabilityList()\ID
        ProcedureReturn SuitabilityList()\Text
      EndIf
    Next
  Else
    ForEach SuitabilityList()
      If SuitabilityList()\ID = Suitability
        ProcedureReturn SuitabilityList()\Text
      EndIf
    Next
  EndIf
  ProcedureReturn
EndProcedure
Procedure.i Get_Suitability_Value(Suitability.s="") 
  ;/ if null is passed in, returns text of currently selected roll
  If Suitability = ""
    ProcedureReturn RollInfo\Suitability
  Else
    ForEach SuitabilityList()
      If SuitabilityList()\Text = Suitability
        ProcedureReturn SuitabilityList()\ID
      EndIf
    Next
  EndIf
  ProcedureReturn
EndProcedure
Procedure.s Get_Site_Name(SiteID.i) 
  ;/ if null is passed in, returns text of currently selected roll
  ForEach SiteList()
    If SiteList()\ID = SiteID
      ProcedureReturn SiteList()\Text
    EndIf
  Next
  ProcedureReturn
EndProcedure
Procedure.i Get_Site_ID(Site.s) 
  ;/ if null is passed in, returns text of currently selected roll
  ForEach SiteList()
    If SiteList()\Text = Site
      ProcedureReturn SiteList()\ID
    EndIf
  Next
  
  ProcedureReturn
EndProcedure
Procedure.i Get_Suitability_Index(Suitability.i=0) 
  ;/ if null is passed in, returns text of currently selected roll
  If Suitability = 0
    ForEach SuitabilityList()
      If RollInfo\Suitability = SuitabilityList()\ID
        ProcedureReturn SuitabilityList()\Count
      EndIf
    Next
  Else
    ForEach SuitabilityList()
      If SuitabilityList()\ID = Suitability
        ProcedureReturn SuitabilityList()\Count
      EndIf
    Next
  EndIf
  ProcedureReturn
EndProcedure
Procedure Flush_Keys()
  Protected MyLoop.i
  For MyLoop = 1 To 255
    GetAsyncKeyState_(MyLoop)
  Next
EndProcedure
Procedure Flush_Events()
  Repeat : Until WindowEvent() = 0
  Flush_Keys()
EndProcedure

Procedure.i WindowShowBalloonTip(window.i,systrayicon.i,title$,content$,timeout.l)
  Protected result.i=#False,balloon.NOTIFYICONDATA_v6
  If OSVersion()>=#PB_OS_Windows_2000
;    If IsSysTrayIcon(systrayicon)
      balloon\hWnd=WindowID(window)
      balloon\uID=systrayicon
      balloon\uFlags=#NIF_INFO
      balloon\dwState=#NIS_SHAREDICON
      balloon\szInfoTitle=title$
      balloon\szInfo=content$
      balloon\uTimeout=timeout
      balloon\dwInfoFlags=#NIIF_NOSOUND
      balloon\cbSize=SizeOf(NOTIFYICONDATA_v6)
      result=Shell_NotifyIcon_(#NIM_MODIFY,balloon)
;    EndIf
  EndIf
  ProcedureReturn result
EndProcedure

Procedure Tool_CheckForUpdate()
  Protected InternalVersion.i, ExternalVersion.s,WhatsNew.s, Ev.i, Lines.i, UpdateFile.s, Width.i, Height.i
  Flush_Events()
  Updatefile.s = "http://www.troika-systems.com/distribution/dotmeters/Current_Rel_AMS2/AMS-Update.txt"
  
;   If Multi_Site_Mode = 1
;     Updatefile.s = "http://www.troika-systems.com/distribution/dotmeters/Current_Rel_AMS2_Multi/AMS-Update.txt"
;   EndIf
;   
  If ReceiveHTTPFile(Updatefile.s,GetTemporaryDirectory()+"AMS-Update.txt") ;/DNT
    If OpenFile(1,GetTemporaryDirectory()+"AMS-Update.txt") ;/DNT
      InternalVersion = Val(ReadString(1))

      If InternalVersion > Program_VersionI
        ExternalVersion = ReadString(1)
        WhatsNew.s = ""
        Lines = 0
        
        Repeat
          WhatsNew + ReadString(1)
          WhatsNew + Chr(10)
          Lines + 1
        Until Eof(1)
        CloseFile(1)
        Width = 480 : height = 320
        OpenWindow(#Window_UpdateCheck,0,0,Width,Height,tTxt(#Str_AMSupdatefound)+"...",#PB_Window_SystemMenu|#PB_Window_WindowCentered)
        StickyWindow(#Window_UpdateCheck,1)
        SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
        EditorGadget(#Gad_Update_NewVersionEditorGadget,2,2,Width - 4,Height-30)
        SendMessage_(GadgetID(#Gad_Update_NewVersionEditorGadget), #EM_SETTARGETDEVICE, #Null, 0) 
;        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,"------------------------------------------------------------") ;/DNT
        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,tTxt(#Str_Newversionavailable)+":"+" "+ExternalVersion)
        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,"----------------------------------------------------------------------------------------------------------------") ;/DNT
        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,"")
;        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,"------------------------------------------------------------------") ;/DNT
        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,WhatsNew)
        AddGadgetItem(#Gad_Update_NewVersionEditorGadget,-1,"----------------------------------------------------------------------------------------------------------------") ;/DNT
        ButtonGadget(#Gad_Update_NewVersionWeblink,2,Height-24,Width-4,20,tTxt(#Str_Downloadnow))
        
        Repeat
          Ev.i = WaitWindowEvent()
          
          Select Ev
            Case #PB_Event_Gadget
              Select EventGadget()
                Case #Gad_Update_NewVersionWeblink
                  If Multi_Site_Mode = 0
                    RunProgram("HTTP://www.troika-systems.com/distribution/dotmeters/Current_Rel_AMS2/Downloads/")
                  Else
                    RunProgram("HTTP://www.troika-systems.com/distribution/dotmeters/Current_Rel_AMS2_Multi/Downloads")
                  EndIf
              EndSelect
          EndSelect

        Until Ev = #PB_Event_CloseWindow
        
        CloseWindow(#Window_UpdateCheck)

      Else ;/ using current version
        CloseFile(1)
        MessageRequester(tTxt(#Str_Message),tTxt(#Str_YourAMSsoftwareisuptodate))
        ProcedureReturn 
      EndIf
    Else
      
      MessageRequester(tTxt(#Str_Message),tTxt(#Str_Unabletocheckforupdateatthistime))
      
    EndIf
  Else
    MessageRequester(tTxt(#Str_Message),tTxt(#Str_Unabletocheckforupdateatthistime)+" "+"("+tTxt(#Str_doyouhaveaworkinginternetconnection)+"?"+")")
  EndIf

EndProcedure
Procedure Tool_TimeTest_Begin()
  System\TimeTest = ElapsedMilliseconds()
EndProcedure
Procedure Tool_TimeTest_End()
  System\TimeTest = ElapsedMilliseconds() - System\TimeTest
EndProcedure

Procedure Init_Fonts_Print(Scale.f)
  Scale - 0.5
  LoadFont(#Font_Report_Dialogs, System\Font_Name, 8 * Scale ,#PB_Font_HighQuality) ;/ #Font_List_S
  LoadFont(#Font_Report_XS, System\Font_Name, System\Font_Size_XS * Scale ,#PB_Font_HighQuality) ;/ #Font_Report_S
  LoadFont(#Font_Report_S, System\Font_Name, System\Font_Size_S * Scale ,#PB_Font_HighQuality) ;/ #Font_Report_S
  LoadFont(#Font_Report_M, System\Font_Name, System\Font_Size_M * Scale ,#PB_Font_Bold|#PB_Font_HighQuality) ;/ #Font_Report_M 
  LoadFont(#Font_Report_L, System\Font_Name, System\Font_Size_L * Scale ,#PB_Font_HighQuality) ;/ #Font_Report_L 
  LoadFont(#Font_Report_L_Bold, System\Font_Name, System\Font_Size_L * Scale ,#PB_Font_Bold|#PB_Font_HighQuality) ;/ #Font_Report_L 
  LoadFont(#Font_Report_XL, System\Font_Name, System\Font_Size_XL * Scale,#PB_Font_HighQuality) ;/ #Font_Report_L 

EndProcedure

Procedure Init_Fonts()

  LoadFont(#Font_List_Dialogs, System\Font_Name,  8 ,#PB_Font_HighQuality) ;/ #Font_List_S
  LoadFont(#Font_List_XS, System\Font_Name,  System\Font_Size_XS ,#PB_Font_HighQuality) ;/ #Font_List_S
  LoadFont(#Font_List_S, System\Font_Name,  System\Font_Size_S ,#PB_Font_HighQuality) ;/ #Font_List_S
  LoadFont(#Font_List_M, System\Font_Name,  System\Font_Size_M ,#PB_Font_Bold|#PB_Font_HighQuality) ;/ #Font_List_M 
  LoadFont(#Font_List_L, System\Font_Name,  System\Font_Size_L ,#PB_Font_HighQuality) ;/ #Font_List_L 
  LoadFont(#Font_List_L_Bold, System\Font_Name,  System\Font_Size_L ,#PB_Font_Bold) ;/ #Font_List_L 
  LoadFont(#Font_List_XL, System\Font_Name, System\Font_Size_XL,#PB_Font_HighQuality) ;/ #Font_List_L 
  
  SetGadgetFont(#PB_Default,FontID(#Font_List_S))

EndProcedure

Procedure DisplaySplash(ImageID,time.i)
  Protected hBrush.i, Alpha.i, ev.i, t.i, Exit.i, Myloop.i

  OpenWindow(#Window_Splash,0,0,ImageWidth(ImageID),ImageHeight(ImageID),"",#PB_Window_BorderLess|#PB_Window_ScreenCentered|#PB_Window_Invisible) ;/DNT
  SetWindowLong_(WindowID(#Window_Splash),#GWL_EXSTYLE,GetWindowLong_(WindowID(#Window_Splash),#GWL_EXSTYLE)|#WS_EX_LAYERED|#WS_EX_TOOLWINDOW)
  hBrush = CreatePatternBrush_(ImageID(ImageID))
  SetClassLong_(WindowID(#Window_Splash),#GCL_HBRBACKGROUND,hBrush)
  InvalidateRect_(WindowID(#Window_Splash),0,1)

  Alpha=0
  Repeat
    ev=WindowEvent()
;    If ev=#PB_Event_CloseWindow:End:EndIf
    SetLayeredWindowAttributes_(WindowID(#Window_Splash),0,Alpha,#LWA_ALPHA)
    Alpha+5
    If GetAsyncKeyState_(#VK_SPACE)&32768 : Exit = 1 : EndIf
    If alpha > 0: HideWindow(#Window_Splash,0) : EndIf
    Delay(16)
  Until Alpha>254 Or Exit = 1
  
  Alpha = 255
  If Exit = 0
    For x = 1 To 750
      Delay(1)
      If GetAsyncKeyState_(#VK_SPACE)&32768 : Exit = 1 : Break : EndIf
    Next
  EndIf 
  t=ElapsedMilliseconds()
  Repeat
    ev=WindowEvent()
    SetLayeredWindowAttributes_(WindowID(#Window_Splash),0,Alpha,#LWA_ALPHA)
    If GetAsyncKeyState_(#VK_SPACE)&32768 : Exit = 1 : EndIf
    Alpha-5
    Delay(16)
    If GetAsyncKeyState_(#VK_SPACE)&32768 : Exit = 1 : EndIf
  Until Alpha<3 Or ElapsedMilliseconds()-t>=2000 Or Exit = 1
  
  CloseWindow(#Window_Splash)
  DeleteObject_(hBrush)
  
  ProcedureReturn 0
EndProcedure
Procedure WindowClientX(Window)
  Protected WindowClientRect.RECT, WindowClientPoint.POINT
  GetWindowRect_(WindowID(Window), @WindowClientRect)
  
  ClientToScreen_(WindowID(Window), @WindowClientPoint)
  ProcedureReturn WindowX(Window) + (WindowClientPoint\x - WindowClientRect\left)
EndProcedure
Procedure WindowClientY(Window)
  Protected WindowClientRect.RECT, WindowClientPoint.POINT
  GetWindowRect_(WindowID(Window), @WindowClientRect)
  
  ClientToScreen_(WindowID(Window), @WindowClientPoint)
  ProcedureReturn WindowY(Window) + (WindowClientPoint\y - WindowClientRect\top)
EndProcedure
Procedure WindowBorder(Window)
  ProcedureReturn WindowClientX(Window) - WindowX(Window)
EndProcedure
Procedure WindowTitleBar(Window)
  ProcedureReturn WindowClientY(Window) - WindowY(Window) - WindowBorder(Window)
EndProcedure
Procedure WindowRealWidth(Window)
  ProcedureReturn WindowWidth(Window) + (WindowBorder(Window) * 2)
EndProcedure
Procedure WindowRealHeight(Window)
  ProcedureReturn WindowTitleBar(Window) + WindowHeight(Window) + (WindowBorder(Window) * 2)
EndProcedure
Procedure.i GetGadgetColumns(Gadget.i)
  Protected column.i, width.i, flag.i
  Column = 0
  Repeat   
    width  = GetGadgetItemAttribute(Gadget,0,#PB_ListIcon_ColumnWidth, column)
    column + 1   
    ;Debug Width
  Until Width = 0
 
  ProcedureReturn column - 1 
EndProcedure

Procedure.i Image_To_Memory(File.S) ;/ 
  Protected Size.i, Image.i, ReScale.f
  
  Size = FileSize(File.S)
  
  If Size < 0 ;/ file not found or not a file?
    Debug "Load AMS image error, File Not Found."
    ProcedureReturn 0
  EndIf
  
  If *ImMem <> 0 : FreeMemory(*ImMem) : EndIf
  *ImMem = AllocateMemory(Size)
  
  Image = LoadImage(#PB_Any,File.s)
  Debug "Imagewidth: "+Str(ImageWidth(Image))
  Debug "ImageHeight: "+Str(ImageHeight(Image))
  
;  ;/ Rescale image if it's larger than 640 x 480
;  If ImageWidth(Image) > 640 Or ImageHeight(Image) > 480
;    Debug "Rescaling imported image"
;    reScale = 640.0 / ImageWidth(Image)
;    If (480.0 / ImageHeight(Image)) > ReScale
;      ReScale = (480.0 / ImageHeight(Image)) 
;    EndIf
;    
;    ResizeImage(Image,ImageWidth(Image)*Rescale,ImageHeight(Image)*Rescale))
    
 ; EndIf
  
  
  If OpenFile(1,File)
    ReadData(1,*ImMem,Size)
    CloseFile(1)
    ProcedureReturn 1
  Else
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_Unabletoopenfile)+"("+tTxt(#Str_Fileopenedelsewhere)+"?"+")",#PB_MessageRequester_Ok)
    ProcedureReturn 0 ;/
  EndIf
  
EndProcedure
Procedure Form_Update_Images()
  Protected Wid.i, Hgt.i
  Debug "Scaling form Images"  
  
  If IsImage(#Image_BorderRolls) 
      If ImageWidth(#Image_BorderRolls_Scaled) <> (GadgetWidth(#Gad_Welcome_BorderRolls)) Or ImageHeight(#Image_BorderRolls_Scaled) <> (GadgetHeight(#Gad_Welcome_BorderRolls))
      Debug "Img BorderRolls: "+Str(#Image_BorderRolls)+" - Img BorderRollScaled: "+Str(#Image_BorderRolls_Scaled)+" - "+Str(IsImage(#Image_BorderRolls))+" - "+Str(IsImage(#Image_BorderRolls_Scaled))
      CopyImage(#Image_BorderRolls,#Image_BorderRolls_Scaled)
      Debug "Img BorderRolls: "+Str(#Image_BorderRolls)+" - Img BorderRollScaled: "+Str(#Image_BorderRolls_Scaled)+" - "+Str(IsImage(#Image_BorderRolls))+" - "+Str(IsImage(#Image_BorderRolls_Scaled))
      Wid = GadgetWidth(#Gad_Welcome_BorderRolls) : Hgt = GadgetHeight(#Gad_Welcome_BorderRolls)
      
      ResizeImage(#Image_BorderRolls_Scaled,Wid,Hgt)
      Debug "Img BorderRolls: "+Str(#Image_BorderRolls)+" - Img BorderRollScaled: "+Str(#Image_BorderRolls_Scaled)+" - "+Str(IsImage(#Image_BorderRolls))+" - "+Str(IsImage(#Image_BorderRolls_Scaled))+" - "+Str(Wid)+","+Str(Hgt)
      SetGadgetState(#Gad_Welcome_BorderRolls,ImageID(#Image_BorderRolls_Scaled))
    EndIf
  EndIf
  
  If IsImage(#Image_2d_Image_Current)
    CopyImage(#Image_2d_Image_Current ,#Image_RollInfo_Current_Scaled)
    ResizeImage(#Image_RollInfo_Current_Scaled,GadgetWidth(#Gad_RollInfo_Image_Latest)-4,GadgetHeight(#Gad_RollInfo_Image_Latest)-4)
    SetGadgetState(#Gad_RollInfo_Image_Latest,ImageID(#Image_RollInfo_Current_Scaled))
  EndIf
  If IsImage(#Image_2d_Image_Reference)
    CopyImage(#Image_2d_Image_Reference,#Image_RollInfo_Referencel_Scaled)
    ResizeImage(#Image_RollInfo_Referencel_Scaled,GadgetWidth(#Gad_RollInfo_Image_Reference)-4,GadgetHeight(#Gad_RollInfo_Image_Reference)-4)
    SetGadgetState(#Gad_RollInfo_Image_Reference,ImageID(#Image_RollInfo_Referencel_Scaled))
  EndIf
  
  If IsImage(#Image_Roll_Large)
    CopyImage(#Image_Roll_Large,#Image_Roll_Large_Scaled)
    ResizeImage(#Image_Roll_Large_Scaled,GadgetWidth(#Gad_RollInfo_Roll_Image),GadgetHeight(#Gad_RollInfo_Roll_Image))
    SetGadgetState(#Gad_RollInfo_Roll_Image,ImageID(#Image_Roll_Large_Scaled))
  EndIf
    
  If IsImage(#Image_Roll_Pins)
    CopyImage(#Image_Roll_Pins,#Image_Roll_Pins_Scaled)
    ResizeImage(#Image_Roll_Pins_Scaled,GadgetWidth(#Gad_RollInfo_Roll_Pins),GadgetHeight(#Gad_RollInfo_Roll_Pins))
    SetGadgetState(#Gad_RollInfo_Roll_Pins,ImageID(#Image_Roll_Pins_Scaled))
  EndIf
  
  If IsImage(#Image_Logo)
    CopyImage(#Image_Logo,#Image_Logo_Scaled)
    ResizeImage(#Image_Logo_Scaled,GadgetWidth(#Gad_TroikaButton),GadgetHeight(#Gad_TroikaButton))
    ;ButtonImageGadget(#Gad_TroikaButton,2,y,280,94,ImageID(#Image_OEM_Logo)) : Y + 96
    SetGadgetAttribute(#Gad_TroikaButton,#PB_Button_Image,ImageID(#Image_OEM_Logo))
  EndIf
  
  If IsImage(#Image_TroikaAMS)
    CopyImage(#Image_TroikaAMS,#Image_TroikaAMS_Scaled)
    ResizeImage(#Image_TroikaAMS_Scaled,GadgetWidth(#Gad_Welcome_TroikaLogo),GadgetHeight(#Gad_Welcome_TroikaLogo))
    SetGadgetState(#Gad_Welcome_TroikaLogo,ImageID(#Image_TroikaAMS_Scaled))
  EndIf

EndProcedure
Procedure Image_Refresh_History(HistoryID.i) ;/
  Protected Length
  DatabaseQuery(#Databases_Master,"Select HistTopSnapImage from AMS_Roll_Data Where ID = '"+Str(HistoryID)+"';")  ;/DNT
  NextDatabaseRow(#Databases_Master)
  
  Length = DatabaseColumnSize(#Databases_Master, 0) ; Display the content of the first field  
  Debug "Length: "+Str(Length)
  If Length > 0
    If System\CurrentImage <> 0 : FreeMemory(System\CurrentImage) : EndIf
    System\CurrentImage = AllocateMemory(Length)
    System\Current_Image_Length = Length
    
    Debug "Memory: "+Str(*ImMem)
    If *imMem > 0
      FreeMemory(*ImMem)
    EndIf
    
    *ImMem = AllocateMemory(Length)
    
    GetDatabaseBlob(#Databases_Master,0,*ImMem,Length)
    CatchImage(#Image_2d_Image_Current ,*ImMem,Length)
    CopyMemory(*ImMem,System\CurrentImage,Length)
  Else
    CopyImage(#NoImageLoaded,#Image_2d_Image_Current)
  EndIf 
  FinishDatabaseQuery(#Databases_Master)
  
  Form_Update_Images()
  
EndProcedure

Procedure.i Check_Manager_Mode()
  
  If System\Manager_Mode = 1
    ProcedureReturn 1
  Else
    MessageRequester(tTxt(#STR_Sorry),tTxt(#STR_Youneedtobeinmanagersmodetocompletethisaction))
    ProcedureReturn 0
  EndIf
  
EndProcedure

Procedure.s EncryptCode(password.s, key.s)
  Debug Len(password.s)
  Protected passin.s        = LSet(password.s, 64, Chr(32))                   ; Pad the password with spaces to make 32 characters   
  Protected keyin.s         = LSet(key.s, 16, Chr(32))                        ; key for 128bit encryption needs length=16
  Protected *encodedbinary = AllocateMemory(64)                             ; 32 bytes for encrypted binary result, see 2 lines down
  Protected *encodedtext   = AllocateMemory(128)                             ; Destination for Base64Encoder must be 33% larger- we double it
  
  Protected *AsciiPass     = AllocateMemory(65)
  Protected *AsciiKey      = AllocateMemory(65)
  PokeS(*AsciiPass,passin.s,Len(passin.s),#PB_Ascii)
  PokeS(*AsciiKey,Keyin.s,Len(Keyin.s),#PB_Ascii)
  
  AESEncoder(*AsciiPass, *encodedbinary, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB) ; We don't encrypt the trailing zero so 32 bytes is enough
  Base64Encoder(*encodedbinary, 64, *encodedtext, 128)                       ; Convert encrypted binary data to ascii for return                     
  ProcedureReturn PeekS(*encodedtext,-1,#PB_Ascii)                                       ; Return the completed ascii result
EndProcedure
Procedure.s DecryptCode(password.s, key.s)
  Protected keyin.s         = LSet(key.s, 16, Chr(32))                            ; key for 128bit decryption needs length=16
  Protected *encodedbinary = AllocateMemory(128)                                 ; 32 bytes for data + one safety byte
  Protected *decodedtext   = AllocateMemory(128)                               ; 32 bytes for characters + one byte for terminating zero
  
  Protected *AsciiPass     = AllocateMemory(128)
  Protected *AsciiKey      = AllocateMemory(128)  
  
  PokeS(*AsciiKey,Keyin.s,Len(keyin.s),#PB_Ascii)
  PokeS(*AsciiPass,password.s,Len(password.s),#PB_Ascii)
  
  Base64Decoder(*AsciiPass, Len(password.s), *encodedbinary, 64)                 ; Convert the ascii encoded password back to binary
  AESDecoder(*encodedbinary, *decodedtext, 64, *AsciiKey, 128, 0, #PB_Cipher_ECB) ; Convert the encrypted password back to original
  ProcedureReturn Trim(PeekS(*decodedtext, -1,#PB_Ascii))                                 ; Remove any trailing spaces and return result
EndProcedure
Procedure.s DeCodeI(String.s)
  If Left(DecryptCode(String.s,"OpenWindow"),3)="ARK"
    ProcedureReturn StringField(DecryptCode(String.s,"OpenWindow"),2,Chr(10))
  Else
    ProcedureReturn String
  EndIf
EndProcedure

Procedure.S UnitConversion_Date(Date.i)
  
  If Date = 0 : ProcedureReturn "-" : EndIf 
  If System\Settings_Date_Format = #Settings_DateUnit_DDMMYYYY
    ProcedureReturn FormatDate("%DD/%MM/%YYYY",Date) ;/DNT
  EndIf 
  If System\Settings_Date_Format = #Settings_DateUnit_MMDDYYYY
    ProcedureReturn FormatDate("%MM/%DD/%YYYY",Date) ;/DNT
  EndIf 
EndProcedure 
Procedure.f UnitConversion_Volume(Vol.f)
  ProcedureReturn Vol
  If System\Settings_Volume_Unit = #Settings_VolumeUnit_BCM
    ProcedureReturn (Vol/1.55)
  EndIf 
  If System\Settings_Volume_Unit = #Settings_VolumeUnit_CM3M2
    ProcedureReturn (Vol)
  EndIf 
EndProcedure 

Procedure.l RollInfo_CheckEditted()
  Protected Editted.i
  
  If System\Showing_Panel = #Panel_Roll_Info
  Editted = 0
  
  If GetGadgetText(#Gad_Rollinfo_RollID_String) <> RollInfo\RollID
    Editted = 1
    Debug "RollIDs Differ"
  EndIf
  ;If GetGadgetState(#Gad_Rollinfo_Manufacturer_String) <> RollInfo\Manufacturer
  If Get_Manufacturer_Value(GetGadgetText(#Gad_Rollinfo_Manufacturer_String)) <> RollInfo\Manufacturer
    Editted = 1
    Debug "Manufacturers Differ"
  EndIf
  If GetGadgetState(#Gad_Rollinfo_DateMade_Date) <> RollInfo\DateMade
    Editted = 1
    Debug "Date Differ: "+Str(GetGadgetState(#Gad_Rollinfo_DateMade_Date))+" - "+Str(RollInfo\DateMade)
  EndIf  
;  If GetGadgetState(#Gad_Rollinfo_Group_Combo)+1 <> RollInfo\Group
;    Editted = 1
;    Debug "Group Differ: "+Str(GetGadgetState(#Gad_Rollinfo_Group_Combo))+" - "+Str(RollInfo\Group)
;  EndIf  
  If Get_Suitability_Value(GetGadgetText(#Gad_Rollinfo_Suitability_String)) <> RollInfo\Suitability
    Editted = 1
    Debug "Suitability Differ"
  EndIf
  If GetGadgetText(#Gad_RollInfo_Screen_String) <> RollInfo\Screen
    Editted = 1
    Debug "Screen Differ"
  EndIf  
  If GetGadgetText(#Gad_RollInfo_Wall_String) <> RollInfo\WallWidth
    Editted = 1
    Debug "WallWidth Differ"
  EndIf  
  If GetGadgetText(#Gad_RollInfo_Opening_String) <> RollInfo\CellOpening
    Editted = 1
    Debug "CellOpening Differ"
  EndIf
  If GetGadgetText(#Gad_RollInfo_Width_String) <> RollInfo\RollWidth
    Editted = 1
    Debug "RollWidth Differ"
  EndIf  
  If GetGadgetText(#Gad_RollInfo_Comment_Box) <> RollInfo\Comments
    Editted = 1
    Debug "Comments Differ"
  EndIf  
  
  ;/ if not Editted, show buttons, else hide
  If Editted > 0
    HideGadget(#Gad_RollInfo_Commit,0)  
    HideGadget(#Gad_RollInfo_Undo,0) 
    System\Editted = 1
  Else
    HideGadget(#Gad_RollInfo_Commit,1)  
    HideGadget(#Gad_RollInfo_Undo,1) 
    System\Editted = 0
  EndIf
EndIf

EndProcedure

Procedure Redraw_RollID(RollID.i, Force.i=0)
  Protected GroupID.S, Result.S, Length.i, VarAmount.f, OnRow.i, Timer.i, SQL.s
  Protected Vol1.f, Vol2.f, Vol3.f, Vol4.f, Vol5.f, Readings.i, AverageVolume.f, Capacity.f, MasterVolume.f, Variance.f, VarMin.f, VarMax.f, Date.i
  Protected Store_Volume.f, Store_Capacity.f, Store_Variance.f
  Protected ChkVolume.f, ChkCapacity.f, ChkVariance.f, ChkDepth.i, Store_Depth.i, Found.i, MyLoop.i, ColumnCount.i, DepthStr.s
  
  ;If RollID = System\Showing_RollID And System\Refresh_Roll_Information = 0 And Force = 0 : ProcedureReturn : EndIf ;/ Prevent refresh (and Flickering) if already displaying selected roll
  
  System\Selected_HistoryID = -1 ;/ set it as if there's no History ID info (-1)
  
  Debug "Drawing RollID: "+Str(RollID)
  ;                0    1        2    3             4       5             6         7         8     9       10
  SQL.s = "Select ID, GroupID, Name, Manufacturer, Width, Suitability, DateMade, ScreenCount,Wall,Opening,Comments,"
  SQL.s + "Operator, ReadingDate, Vol1,Vol2,Vol3,Vol4,Vol5,Volume, Capacity, Variance, Depth, Current_Depth"
  ;           11        12         13   14   15   16  17     18       19        20   ,  21,     22
  
  ;DatabaseQuery(#Databases_Master, "Select * From AMS_Roll_Master WHERE ID = '"+Str(RollID)+"';")
  DatabaseQuery(#Databases_Master, SQL + " From AMS_Roll_Master WHERE ID = '"+Str(RollID)+"';")
  NextDatabaseRow(#Databases_Master)
  
  If DatabaseColumns(#Databases_Master) = 0 : FinishDatabaseQuery(#Databases_Master) : ProcedureReturn : EndIf ;/ a 'gotcha' if an unknown RollId is requested
  
;  SendMessage_(WindowID(#Window_Main),#WM_SETREDRAW,#False,0)
  
;  ;/ Roll - Master Data
;  SQL = "Create TABLE [AMS_Roll_Master] ( [ID0] INTEGER PRIMARY KEY,  [GroupID1] Int,  [Name2] CHAR,  [Type3] CHAR, [Manufacturer4] Int,  [Width5] FLOAT, "
;  SQL + "[Diameter6] INT, [Suitability7] INT,  [DateMade8] INT,  [Screencount9] INT, [Wall10] INT, [Opening11] INT, [Customer12] CHAR," ;/ anilox types
;  SQL + "[Channel13] FLOAT, [Angle14] INT, [StylusAngle15] FLOAT, " ;/ gravure types
;  SQL + "[Comments16] CHAR,  [Operator17] CHAR, [ReadingDate18] Int, [Vol119] FLOAT,  [Vol220] FLOAT,  [Vol321] FLOAT,  [Vol422] FLOAT,  [Vol523] FLOAT, [Volume24] Float, [Capacity25] Float, [Variance26] Float, [LastReadingDate27] INT, " ;/ Master Reading
;  SQL + "[PPMM28] Float, [TopSnapImage29] LONGBINARY, [InfSnapImage30] LONGBINARY, [3dData31] LONGBINARY)"
;  CheckDatabaseUpdate(#Databases_Master, SQL)
  
  ;/ Store RollInfo in new structure - allows for edit check later on
  RollInfo\Group = GetDatabaseLong(#Databases_Master,1)
  RollInfo\RollID = GetDatabaseString(#Databases_Master,2)
  RollInfo\Manufacturer = GetDatabaseLong(#Databases_Master,3)
  RollInfo\RollWidth = Str(Val(GetDatabaseString(#Databases_Master,4)))
  RollInfo\Suitability = GetDatabaseLong(#Databases_Master,5)
  RollInfo\DateMade = GetDatabaseLong(#Databases_Master,6)
  RollInfo\Screen = GetDatabaseString(#Databases_Master,7)
  RollInfo\WallWidth = GetDatabaseString(#Databases_Master,8)
  RollInfo\CellOpening = GetDatabaseString(#Databases_Master,9)
  RollInfo\Comments = GetDatabaseString(#Databases_Master,10)
  RollInfo\Depth = GetDatabaseLong(#Databases_Master,21)
  
  DepthStr = Str(Rollinfo\Depth)
  If DepthStr = "0" : DepthStr = "" : EndIf
  If System\Show_Depth = 0 : DepthStr = "" : EndIf
  
  ChkVolume = GetDatabaseFloat(#Databases_Master,18)
  ChkCapacity = GetDatabaseFloat(#Databases_Master,19)
  ChkVariance = GetDatabaseFloat(#Databases_Master,20)
  ChkDepth = GetDatabaseLong(#Databases_Master,22)
  Store_Depth = RollInfo\Depth
  
  ;/ Set selected RollID to viewing Roll

  System\Last_Drawn_Roll =  RollID ;/ store for when needed to redraw (settings change etc,.)
  System\Selected_Roll_ID = RollID
  
  ;/ ************ Set the gadget texts based on settings ************
  
  ;/ Date - need to change the gadget settings

  If System\Settings_Date_Format = #Settings_DateUnit_DDMMYYYY
    Debug "Date: DDMMYYYY"
    SetGadgetText(#Gad_Rollinfo_DateMade_Date,"%dd/%mm/%yyyy") ;/DNT
  Else
    Debug "Date: MMDDYYYY"
    SetGadgetText(#Gad_Rollinfo_DateMade_Date,"%mm/%dd/%yyyy") ;/DNT
  EndIf

  SetGadgetItemText(#Gad_RollInfo_Original_List,0,System\Settings_Volume_UnitMask,8)
  SetGadgetItemText(#Gad_RollInfo_History_List,-1,System\Settings_Volume_UnitMask,8)
  
  ;/ Opening, Wall (Micron / thou)
  SetGadgetText(#Gad_RollInfo_Wall_UnitText,System\Settings_Length_UnitMask)
  SetGadgetText(#Gad_RollInfo_Opening_UnitText,System\Settings_Length_UnitMask)
  
  ;/ Screen (LPI / LPCM)
  If System\Settings_Screen_Unit = #Settings_ScreenUnit_LPI
    SetGadgetText(#Gad_RollInfo_Screen_UnitText,System\Settings_Screen_UnitMask)
  Else
    SetGadgetText(#Gad_RollInfo_Screen_UnitText,System\Settings_Screen_UnitMask)
  EndIf

  SetGadgetText(#Gad_Rollinfo_RollID_String,RollInfo\RollID)
  System\Selected_Roll_ID_Text = GetGadgetTextMac(#Gad_Rollinfo_RollID_String)
  System\Selected_Roll_ID = RollID
  
  If RollInfo\Group > 0
    Debug "Roll Group: "+Str(Rollinfo\Group)+" - of "+Str(ListSize(Database_GroupList()))
    ;/ Crash Occurred 
    Found = 0
    ForEach Database_GroupList()
      If Database_GroupList()\ID = Rollinfo\Group : Found = 1 : Break : EndIf
    Next

    If found = 0 : MessageRequester(tTxt(#Str_Error)+", "+tTxt(#Str_groupnotfound),tTxt(#Str_Shouldneverseethismessagebox)) : EndIf ;/BNT
    GroupID.S = Database_GroupList()\Text
  EndIf
  ;/ 92... 87...
  Debug "GroupID on RedrawRollID: "+GroupID+" - ID: "+Str(RollInfo\Group)
  
  ;  SetGadgetState(#Gad_Rollinfo_Manufacturer_String,RollInfo\Manufacturer)
  Debug "Getting Manufacturer Value - Roll Manufacturer: "+Str(RollInfo\Manufacturer)+" - ComboBoxID: "+Str(Get_Suitability_Index(RollInfo\Manufacturer))
  SetGadgetState(#Gad_Rollinfo_Manufacturer_String,Get_Manufacturer_Index(RollInfo\Manufacturer))

  SetGadgetText(#Gad_RollInfo_Width_String,RollInfo\RollWidth)
  Debug "Getting Suitability Value - Roll Suitability: "+Str(RollInfo\Suitability)+" - ComboBoxID: "+Str(Get_Suitability_Index(RollInfo\Suitability))
  SetGadgetState(#Gad_Rollinfo_Suitability_String,Get_Suitability_Index(RollInfo\Suitability))
  SetGadgetState(#Gad_Rollinfo_DateMade_Date,RollInfo\DateMade)
  RollInfo\DateMade = GetGadgetState(#Gad_Rollinfo_DateMade_Date) ;/ Date gadget doesn't store seconds??
  SetGadgetText(#Gad_RollInfo_Screen_String,RollInfo\Screen)
  SetGadgetText(#Gad_RollInfo_Wall_String,RollInfo\WallWidth)
  SetGadgetText(#Gad_RollInfo_Opening_String,RollInfo\CellOpening)
  SetGadgetText(#Gad_RollInfo_Comment_Box,Rollinfo\Comments)
  
  Date = GetDatabaseLong(#Databases_Master,12)

  ClearGadgetItems(#Gad_RollInfo_Original_List)
  
  If Date > 0 ;/ only populate the reading text if there's data there
    Result.S = UnitConversion_Date(Date) + Chr(10)+GetDatabaseString(#Databases_Master,11) 

    ;/ Master Roll information
    
    Readings = 0 : AverageVolume = 0
    
    Vol1.f = GetDatabaseFloat(#Databases_Master,13) : If Vol1 > 0 : Readings + 1 : AverageVolume + Vol1 : Result + Chr(10) + StrFs(Vol1,1) : Else : Result + Chr(10) :  EndIf 
    Vol2.f = GetDatabaseFloat(#Databases_Master,14) : If Vol2 > 0 : Readings + 1 : AverageVolume + Vol2 : Result + Chr(10) + StrFs(Vol2,1) : Else : Result + Chr(10) :  EndIf 
    Vol3.f = GetDatabaseFloat(#Databases_Master,15) : If Vol3 > 0 : Readings + 1 : AverageVolume + Vol3 : Result + Chr(10) + StrFs(Vol3,1) : Else : Result + Chr(10) :  EndIf 
    Vol4.f = GetDatabaseFloat(#Databases_Master,16) : If Vol4 > 0 : Readings + 1 : AverageVolume + Vol4 : Result + Chr(10) + StrFs(Vol4,1) : Else : Result + Chr(10) :  EndIf 
    Vol5.f = GetDatabaseFloat(#Databases_Master,17) : If Vol5 > 0 : Readings + 1 : AverageVolume + Vol5 : Result + Chr(10) + StrFs(Vol5,1) : Else : Result + Chr(10) :  EndIf 

    VarMin = 999 : VarMax = 0
    
    If Vol1 > 0 And Vol1 < VarMin : VarMin = Vol1 : EndIf
    If Vol2 > 0 And Vol2 < VarMin : VarMin = Vol2 : EndIf
    If Vol3 > 0 And Vol3 < VarMin : VarMin = Vol3 : EndIf
    If Vol4 > 0 And Vol4 < VarMin : VarMin = Vol4 : EndIf
    If Vol5 > 0 And Vol5 < VarMin : VarMin = Vol5 : EndIf
    
    If Vol1 > VarMax : VarMax = Vol1 : EndIf
    If Vol2 > VarMax : VarMax = Vol2 : EndIf
    If Vol3 > VarMax : VarMax = Vol3 : EndIf
    If Vol4 > VarMax : VarMax = Vol4 : EndIf
    If Vol5 > VarMax : VarMax = Vol5 : EndIf  
    
    MasterVolume = AverageVolume / Readings
    
    Result + Chr(10) + "=" + Chr(10)+ StrFs(MasterVolume,1) + Chr(10)
    VarAmount = (1.0-(VarMin/VarMax))*100.0
    Result + Str(VarAmount)+"%" + Chr(10)+"100%"+Chr(10)+DepthStr
    
    If System\Show_Depth = 0
      AddGadgetItem(#Gad_RollInfo_Original_List,-1,tTxt(#Str_Date)+Chr(10)+tTxt(#Str_Examiner)+Chr(10)+"1"+Chr(10)+"2"+Chr(10)+"3"+Chr(10)+"4"+Chr(10)+"5"+Chr(10)+"="+Chr(10)+System\Settings_Volume_UnitMask+Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity))
    Else
      AddGadgetItem(#Gad_RollInfo_Original_List,-1,tTxt(#Str_Date)+Chr(10)+tTxt(#Str_Examiner)+Chr(10)+"1"+Chr(10)+"2"+Chr(10)+"3"+Chr(10)+"4"+Chr(10)+"5"+Chr(10)+"="+Chr(10)+System\Settings_Volume_UnitMask+Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity)+Chr(10)+tTxt(#Str_Depth))
    EndIf

    AddGadgetItem(#Gad_RollInfo_Original_List,-1,Result)
    ColumnCount = 10
    If System\Show_Depth = 1 : ColumnCount = 11 : EndIf
    For MyLoop = 0 To ColumnCount
      SetGadgetItemColor(#Gad_RollInfo_Original_List,0,#PB_Gadget_BackColor,RGB(180,180,180),MyLoop)
    Next

    SetGadgetItemColor(#Gad_RollInfo_Original_List,1,#PB_Gadget_FrontColor,RGB(250,250,250),10)
    SetGadgetItemColor(#Gad_RollInfo_Original_List,1,#PB_Gadget_BackColor,#Database_Colour_Good,10)
    
    If VarAmount <= System\Settings_Variance_Good
      SetGadgetItemColor(#Gad_RollInfo_Original_List,1,#PB_Gadget_FrontColor,#Database_Colour_Good,9)
    EndIf
    If VarAmount > System\Settings_Variance_Good And VarAmount < System\Settings_Variance_Bad
      SetGadgetItemColor(#Gad_RollInfo_Original_List,1,#PB_Gadget_FrontColor,#Database_Colour_Okay,9)
    EndIf
    If VarAmount >= System\Settings_Variance_Bad
      SetGadgetItemColor(#Gad_RollInfo_Original_List,1,#PB_Gadget_FrontColor,#Database_Colour_Bad,9)
    EndIf

    Store_Volume.f   = MasterVolume
    Store_Capacity.f = 100
    Store_Variance.f = VarAmount
    
  EndIf
  FinishDatabaseQuery(#Databases_Master)

  ;/ Populate historic readings
  
  ;   SQL = "Create TABLE [AMS_Roll_Data] ( [ID] INTEGER PRIMARY KEY,  [RollID] INT,  [Date] INT,  [Operative] CHAR, "
  ;   SQL + "[Vol1] FLOAT,  [Vol2] FLOAT,  [Vol3] FLOAT,  [Vol4] FLOAT,  [Vol5] FLOAT,"
  ;   SQL + "[Capacity] FLOAT,  [Image] BLOB);"
  
  SQL = "Select ID,  RollID,  ReadingDate, Operator, Vol1, Vol2, Vol3, Vol4, Vol5, Depth From AMS_Roll_Data WHERE RollID = '"+Str(RollID)+"' Order by ReadingDate Desc;"
  ;              0       1         2           3        4    5     6     7     8      9
  DatabaseQuery(#Databases_Master, SQL) ;/ *!* Get away from the "*" business!  Specify Fields!
  
  ClearGadgetItems(#Gad_RollInfo_History_List)
  ClearList(HistoryList())
  OnRow = 0
  While NextDatabaseRow(#Databases_Master)
    Result.S = UnitConversion_Date(GetDatabaseLong(#Databases_Master,2)) + Chr(10)+GetDatabaseString(#Databases_Master,3) 

    Readings = 0 : AverageVolume = 0

    Vol1.f = GetDatabaseFloat(#Databases_Master,4) : If Vol1 > 0 : Readings + 1 : AverageVolume + Vol1 : Result + Chr(10) + StrFs(Vol1,1) : Else : Result + Chr(10) :  EndIf 
    Vol2.f = GetDatabaseFloat(#Databases_Master,5) : If Vol2 > 0 : Readings + 1 : AverageVolume + Vol2 : Result + Chr(10) + StrFs(Vol2,1) : Else : Result + Chr(10) :  EndIf 
    Vol3.f = GetDatabaseFloat(#Databases_Master,6) : If Vol3 > 0 : Readings + 1 : AverageVolume + Vol3 : Result + Chr(10) + StrFs(Vol3,1) : Else : Result + Chr(10) :  EndIf 
    Vol4.f = GetDatabaseFloat(#Databases_Master,7) : If Vol4 > 0 : Readings + 1 : AverageVolume + Vol4 : Result + Chr(10) + StrFs(Vol4,1) : Else : Result + Chr(10) :  EndIf 
    Vol5.f = GetDatabaseFloat(#Databases_Master,8) : If Vol5 > 0 : Readings + 1 : AverageVolume + Vol5 : Result + Chr(10) + StrFs(Vol5,1) : Else : Result + Chr(10) :  EndIf 
    
    DepthStr = Str(GetDatabaseLong(#Databases_Master,9))
    If DepthStr = "0" : DepthStr = "" : EndIf
    If System\Show_Depth = 0 : DepthStr = "" : EndIf
    
    VarMin = 999 : VarMax = 0
    
    If Vol1 > 0 And Vol1 < VarMin : VarMin = Vol1 : EndIf
    If Vol2 > 0 And Vol2 < VarMin : VarMin = Vol2 : EndIf
    If Vol3 > 0 And Vol3 < VarMin : VarMin = Vol3 : EndIf
    If Vol4 > 0 And Vol4 < VarMin : VarMin = Vol4 : EndIf
    If Vol5 > 0 And Vol5 < VarMin : VarMin = Vol5 : EndIf
    
    If Vol1 > VarMax : VarMax = Vol1 : EndIf
    If Vol2 > VarMax : VarMax = Vol2 : EndIf
    If Vol3 > VarMax : VarMax = Vol3 : EndIf
    If Vol4 > VarMax : VarMax = Vol4 : EndIf
    If Vol5 > VarMax : VarMax = Vol5 : EndIf  
    
    Result + Chr(10) + "=" +Chr(10) + StrFs(AverageVolume / Readings, 1) + Chr(10)
 
    VarAmount = (1.0-(VarMin/VarMax))*100.0
    Result + Str(VarAmount)+"%" + Chr(10)
    Capacity = ((AverageVolume / Readings) / MasterVolume) * 100.0
 
    Result + Str(Capacity)+"%"+Chr(10)+DepthStr

    AddElement(HistoryList())
    HistoryList() = GetDatabaseLong(#Databases_Master,0)

    AddGadgetItem(#Gad_RollInfo_History_List,-1,Result)
    
    SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_FrontColor,RGB(250,250,250),10)
    If Capacity >= System\Settings_Capacity_Good
      SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_BackColor,#Database_Colour_Good,10)
    EndIf
    If Capacity < System\Settings_Capacity_Good And Capacity > System\Settings_Capacity_Bad
      SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_BackColor,#Database_Colour_Okay,10)
    EndIf
    If Capacity <= System\Settings_Capacity_Bad
      SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_BackColor,#Database_Colour_Bad,10)
    EndIf

    If VarAmount <= System\Settings_Variance_Good
      SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_FrontColor,#Database_Colour_Good,9)
    EndIf
    If VarAmount > System\Settings_Variance_Good And VarAmount < System\Settings_Variance_Bad
      SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_FrontColor,#Database_Colour_Okay,9)
    EndIf
    If VarAmount >= System\Settings_Variance_Bad
      SetGadgetItemColor(#Gad_RollInfo_History_List,OnRow,#PB_Gadget_FrontColor,#Database_Colour_Bad,9)
    EndIf

    If OnRow = 0 ;/ first row will be the latest on the new sort order
      Store_Volume.f   = (AverageVolume / Readings)
      Store_Capacity.f = Capacity
      Store_Variance.f = VarAmount
      Store_Depth = Val(DepthStr)
      System\Selected_HistoryID = HistoryList() ;/ set it as if there's no History ID info (-1)
      Debug "HistoryListID: "+Str(HistoryList())
    EndIf
    OnRow + 1
  Wend
  FinishDatabaseQuery(#Databases_Master)
  
  ;/ last record out *should* be the last reading, so write to Master Roll database
  
  ;/ [Volume] Float, [Capacity] Float, [Variance] Float
  If StrF(Store_Volume,1) <> StrF(ChkVolume,1) Or Str(Store_Capacity) <> Str(ChkCapacity) Or Str(Store_Variance) <> Str(ChkVariance) Or ChkDepth <> Store_Depth
    If StrF(Store_Volume,1) <> StrF(ChkVolume,1) : Debug "ChkVol: "+StrF(ChkVolume,1)+","+StrF(Store_Volume,1)+" - ***Difference" : EndIf
    If Str(Store_Capacity) <> Str(ChkCapacity) : Debug "ChkCap: "+Str(ChkCapacity)+","+Str(Store_Capacity)+" - ***Difference" : EndIf
    If Str(Store_Variance) <> Str(ChkVariance) : Debug "ChkVar: "+Str(ChkVariance)+","+Str(Store_Variance)+" - ***Difference" : EndIf
    If Store_Depth <> ChkDepth : Debug "ChkDepth: "+ChkDepth+","+Store_Depth+" - ***Difference" : EndIf
    System\DatabaseWrites + 1
    
    Database_Update(#Databases_Master,"Update AMS_Roll_Master SET Volume = '"+StrF(Store_Volume,1)+"', Capacity = '"+Str(Store_Capacity)+"', Variance = '"+Str(Store_Variance)+"', Current_Depth = '"+Str(Store_Depth)+"' Where ID = '"+Str(RollID)+"';",#PB_Compiler_Line)
    
  EndIf
  
  ;/ Populate Damage information  "Create TABLE [AMS_General_History] ( [ID0] AUTOINC,  [RollID1] INT,  [Date2] INT,  [Type3] CHAR,  [Size4] CHAR, [Location5] CHAR, [Comment6] CHAR);"

  DatabaseQuery(#Databases_Master, "Select * From AMS_General_History WHERE RollID = '"+Str(RollID)+"' Order by Date Desc;")
  ClearGadgetItems(#Gad_RollInfo_GeneralHistory_History_List)
  ClearList(DamageList())
  
  While NextDatabaseRow(#Databases_Master)
    Result.S = UnitConversion_Date(GetDatabaseLong(#Databases_Master,2)) + Chr(10) + GetDatabaseString(#Databases_Master,3) + Chr(10) + GetDatabaseString(#Databases_Master,4) + Chr(10) + GetDatabaseString(#Databases_Master,5) 
    AddGadgetItem(#Gad_RollInfo_GeneralHistory_History_List,-1,Result)
    
    AddElement(DamageList())
    DamageList() = GetDatabaseLong(#Databases_Master,0)
    ;Debug "DamagelistID: "+Str(DamageList())
  Wend
  FinishDatabaseQuery(#Databases_Master)
  
  ;/ Extract Images from Database Blobs
  
  ;/ set to noimage
  CopyImage(#NoImageLoaded,#Image_2d_Image_Reference)
  CopyImage(#NoImageLoaded,#Image_2d_Image_Current)
  System\Current_Image_Length = 0
  System\Reference_Image_Length = 0

  DatabaseQuery(#Databases_Master,"Select TopSnapImage from AMS_Roll_Master Where ID = '"+Str(RollID)+"';")
  NextDatabaseRow(#Databases_Master)
  Debug "ColumnType: "+Str(DatabaseColumnType(#Databases_Master,0))
  Length = DatabaseColumnSize(#Databases_Master, 0) ; Display the content of the first field  
  ;MessageRequester("Message","Length: "+Str(Length))
  If Length > 0
    If System\ReferenceImage <> 0 : FreeMemory(System\ReferenceImage) : EndIf
    System\ReferenceImage = AllocateMemory(Length)
    System\Reference_Image_Length = Length
    GetDatabaseBlob(#Databases_Master,0,System\ReferenceImage,Length)
    CatchImage(#Image_2d_Image_Reference,System\ReferenceImage,Length)
    
  EndIf 
  FinishDatabaseQuery(#Databases_Master)
  
  ;/ Must check if historical readings are present!  
  If System\Selected_HistoryID > -1
    DatabaseQuery(#Databases_Master,"Select HistTopSnapImage from AMS_Roll_Data Where ID = '"+Str(System\Selected_HistoryID)+"';")
    NextDatabaseRow(#Databases_Master)
    Length = DatabaseColumnSize(#Databases_Master, 0) ; Display the content of the first field  
    ;Debug "**** Blob Length: "+Str(Length)
    ;Debug System\Selected_HistoryID
    If Length > 0
      If System\CurrentImage <> 0 : FreeMemory(System\CurrentImage) : EndIf
      System\CurrentImage = AllocateMemory(Length)
      System\Current_Image_Length = Length
      GetDatabaseBlob(#Databases_Master,0,System\CurrentImage,Length)
      CatchImage(#Image_2d_Image_Current ,System\CurrentImage,Length)
    EndIf 
    FinishDatabaseQuery(#Databases_Master)
  EndIf
  
  Form_Update_Images()
  
  ;/ Populate Group Name
  ;  Result.S = Database_StringQuery("Select Name From AMS_Groups WHERE ID = "+GroupID+";")
  ;SetGadgetState(#Gad_Rollinfo_Group_Combo,RollInfo\Group-1)

  SetGadgetText(#Gad_Rollinfo_Group_Combo,GroupID)
  System\TimeStamp_Roll = Database_GetRollTimeStamp(RollID)
  
  
  ;  FinishDatabaseQuery(#Databases_Master)
  RollInfo_CheckEditted()
  System\Showing_RollID = RollID
  Timer = ElapsedMilliseconds()-Timer
  
  ;SendMessage_(WindowID(#Window_Main),#WM_SETREDRAW,#True,0)
  Flush_Events()
  Debug "Time taken for refresh: "+Str(Timer)
EndProcedure
Procedure Redraw_HomeScreen()
  
  Protected Y.i = 40, X.i = 290, DateI14.i, DateI6W.i, DateI6m.i, SQL.s, CountI.i, Txt.s, Count.i
  
  SetGadgetText(#Gad_Welcome_Location,DecodeI(Database_StringQuery("Select Location from AMS_CompanyInfo" ))) ;/DNT
  SetGadgetText(#Gad_Welcome_Country,DecodeI(Database_StringQuery("Select Country from AMS_CompanyInfo"))) ;/DNT
  SetGadgetText(#Gad_Welcome_Contact_Name,DecodeI(Database_StringQuery("Select ContactName from AMS_CompanyInfo" ))) ;/DNT
  SetGadgetText(#Gad_Welcome_ContactEmail,DecodeI(Database_StringQuery("Select ContactEmail from AMS_CompanyInfo"))) ;/DNT
  SetGadgetText(#Gad_Welcome_Contact_Number,DecodeI(Database_StringQuery("Select ContactNumber from AMS_CompanyInfo" ))) ;/DNT
  
  If Multi_Site_Mode = 0
    SetGadgetText(#Gad_Welcome_Group_Count,Str(Database_CountQuery("Select Count(*) from AMS_Groups",#PB_Compiler_Line ))) ;/DNT
  Else
    If System\DefaultOnly = 1
      SetGadgetText(#Gad_Welcome_Group_Count,Str(Database_CountQuery("Select Count(*) from AMS_Groups Where SiteID = "+Str(System\Default_Site)+";",#PB_Compiler_Line ))) ;/DNT
    Else
      SetGadgetText(#Gad_Welcome_Group_Count,Str(Database_CountQuery("Select Count(*) from AMS_Groups",#PB_Compiler_Line ))) ;/DNT
    EndIf
  EndIf
  
  ;  SQL.s = "Select Count(*) From AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(System\Default_Site)
  If Multi_Site_Mode = 0
    Count.i = Database_CountQuery("Select Count(*) from AMS_Roll_Master",#PB_Compiler_Line) ;/DNT
  Else
    If System\DefaultOnly = 1
      Count.i = Database_CountQuery("Select Count(*) From AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(System\Default_Site),#PB_Compiler_Line) ;/DNT
    Else
      Count.i = Database_CountQuery("Select Count(*) from AMS_Roll_Master",#PB_Compiler_Line) ;/DNT
    EndIf
  EndIf
  
    If System\Settings_RollLimit <> 99999
    SetGadgetText(#Gad_Welcome_Roll_Count,Str(Count) + " (of "+Str(System\Settings_RollLimit)+")")
  Else
    SetGadgetText(#Gad_Welcome_Roll_Count,Str(Count) + " (of *Unlimited*)")
  EndIf
  ;SetGadgetText(#Gad_Welcome_Roll_Count,Str(Count)+ "  /  "+Str(System\Settings_RollLimit))
  
  ;/ 604800 = 1 week
  If Multi_Site_Mode = 0
    DateI14.i = Date()-(604800*2)
    SetGadgetText(#Gad_Welcome_Rolls_Profiled14Days,Str(Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI14),#PB_Compiler_Line))) ;/DNT
    
    DateI6W.i = Date()-(604800*6)
    SetGadgetText(#Gad_Welcome_Rolls_Profiled6Weeks,Str(Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI6W),#PB_Compiler_Line))) ;/DNT
    
    DateI6m.i = Date()-(604800*26)
    SetGadgetText(#Gad_Welcome_Rolls_Profiled6Months,Str(Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI6M),#PB_Compiler_Line))) ;/DNT
  Else
    If System\DefaultOnly = 1
      DateI14.i = Date()-(604800*2)
      SQL.s = "Select Count(*) From AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(System\Default_Site)
      
      SetGadgetText(#Gad_Welcome_Rolls_Profiled14Days,Str(Database_CountQuery(SQL + " and LastReadingDate > "+Str(DateI14)+";",#PB_Compiler_Line))) ;/DNT
      
      DateI6W.i = Date()-(604800*6)
      SetGadgetText(#Gad_Welcome_Rolls_Profiled6Weeks,Str(Database_CountQuery(SQL + " and LastReadingDate > "+Str(DateI6W)+";",#PB_Compiler_Line))) ;/DNT
      
      DateI6m.i = Date()-(604800*26)
      SetGadgetText(#Gad_Welcome_Rolls_Profiled6Months,Str(Database_CountQuery(SQL + " and LastReadingDate > "+Str(DateI6m)+";",#PB_Compiler_Line))) ;/DNT
    Else
      DateI14.i = Date()-(604800*2)
      SetGadgetText(#Gad_Welcome_Rolls_Profiled14Days,Str(Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI14),#PB_Compiler_Line))) ;/DNT
      
      DateI6W.i = Date()-(604800*6)
      SetGadgetText(#Gad_Welcome_Rolls_Profiled6Weeks,Str(Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI6W),#PB_Compiler_Line))) ;/DNT
      
      DateI6m.i = Date()-(604800*26)
      SetGadgetText(#Gad_Welcome_Rolls_Profiled6Months,Str(Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI6M),#PB_Compiler_Line))) ;/DNT
      
    EndIf
  EndIf
  
  System\TimeStamp_Main = Database_GetMainTimeStamp()
  
EndProcedure

Procedure Redraw_NavTree()
  Protected MyLoop.i, Site_Loop.i, Group_Loop.i, Roll_Loop.i, Site_Count.i, Group_Count.i, Roll_Count.i, Site_ID.i, Group_ID.i
  Protected TreeString.S, GadPos.i, GadState.i, Time.i
  
  Message_Add("***Navtree refresh***")
  Time = ElapsedMilliseconds()

  ClearList(Sites()) : ClearList(Groups()) : ClearList(Rolls()) : ClearList(NavTree())
  
  ;/ Insert Company
  AddElement(NavTree())
  NavTree()\Type = #NavTree_Company ;/ Company
  NavTree()\String = System\Database_Company ;/ company name  
  Site_Count = Database_CountQuery("Select Count(*) from AMS_Sites;",#PB_Compiler_Line)
  
  ;/ Read in all sites
  If Multi_Site_Mode = 0
    DatabaseQuery(0, "Select ID, Name From AMS_Sites order by Name+0;")
    While NextDatabaseRow(0)
      AddElement(Sites())
      Sites()\ID = GetDatabaseQuad(0,0)
      Sites()\Name = GetDatabaseString(0,1)
    Wend
    FinishDatabaseQuery(0)
  Else
    If System\DefaultOnly = 1
      Debug "Filtering by Default Site: "+Str(System\Default_Site)
      DatabaseQuery(0, "Select ID, Name From AMS_Sites where ID = "+Str(System\Default_Site)+";")
      ;DatabaseQuery(0, "Select ID, Name From AMS_Sites;")
    Else
      DatabaseQuery(0, "Select ID, Name From AMS_Sites;")
    EndIf
    
    While NextDatabaseRow(0)
      AddElement(Sites())
      Sites()\ID = GetDatabaseQuad(0,0)
      Sites()\Name = GetDatabaseString(0,1)
      
      If Sites()\ID = System\Default_Site And System\DefaultOnly = 0
        Sites()\Name = "*" + Sites()\Name
      EndIf 
    Wend
  EndIf

  DatabaseQuery(0, "Select ID, GroupName, SiteID From AMS_Groups Order by Type, GroupName;")
  ;DatabaseQuery(0, "Select ID, GroupName, SiteID From AMS_Groups Order by (GroupName+0)ASC;")
  While NextDatabaseRow(0)
    AddElement(Groups())
    Groups()\ID = GetDatabaseQuad(0,0)
    Groups()\Name = GetDatabaseString(0,1)
    Groups()\Parent = GetDatabaseQuad(0,2)
  Wend
  FinishDatabaseQuery(0)
  
;  DatabaseQuery(0, "Select ID, Name, GroupID From AMS_Roll_Master Order by Name;")
  DatabaseQuery(0, "Select ID, Name, GroupID From AMS_Roll_Master Order by Name, Name+'0';")
  ;DatabaseQuery(0, "Select ID, Name, GroupID From AMS_Roll_Master Order by CASE WHEN Name GLOB '*[^0-9.]*' THEN Name ELSE cast(Name AS real);")
  While NextDatabaseRow(0)
    AddElement(Rolls())
    Rolls()\ID = GetDatabaseQuad(0,0)
    Rolls()\Name = GetDatabaseString(0,1)
    Rolls()\Parent = GetDatabaseLong(0,2)
  Wend
  FinishDatabaseQuery(0)
  
  ForEach Sites()
    ForEach Groups()
      If Groups()\Parent = Sites()\ID
        Sites()\Count + 1
        ForEach Rolls()
          If Rolls()\Parent = Groups()\ID
            Groups()\Count + 1
          EndIf
        Next
      EndIf
    Next
  Next
  
  ;/ now, from raw data, build up tree
  ForEach Sites()
    AddElement(NavTree())
    NavTree()\SiteID = Sites()\ID
    Navtree()\Type = #NavTree_Site
    Navtree()\String = Sites()\Name
    Navtree()\AddString = " ["+Str(Sites()\Count)+"]"

    ForEach Groups()
      If Groups()\Parent = Sites()\ID
        AddElement(Navtree())
        ;Sites()\Count + 1
        Navtree()\SiteID = Sites()\ID
        NavTree()\GroupID = Groups()\ID
        Navtree()\Type = #NavTree_Group
        Navtree()\String = Groups()\Name
        Navtree()\AddString = " ["+Str(Groups()\Count)+"]"
        ForEach Rolls()
          If Rolls()\Parent = Groups()\ID
            ;Groups()\Count + 1
            AddElement(Navtree())
            Navtree()\SiteID = Sites()\ID
            NavTree()\GroupID = Groups()\ID
            Navtree()\RollID = Rolls()\ID
            Navtree()\String = Rolls()\Name
            Navtree()\Type = #NavTree_Roll
          EndIf
        Next
      EndIf
    Next
  Next
  
  Message_Add("*** Navtree finished: "+Str(ElapsedMilliseconds()-Time)+"ms - ***")
  
  ;/ populate treegadget array (now we know what tree item holds what information).
  ClearGadgetItems(#Gad_NavTree)
  Debug "NavTree Size after Update: "+Str(ListSize(NavTree()))
  GadPos = 0
  GadState = 0
  ForEach NavTree()
    TreeString.S = NavTree()\String + NavTree()\AddString
    If NavTree()\Type = #NavTree_Company : AddGadgetItem(#Gad_NavTree,-1,TreeString,ImageID(#Image_TreeView_Home),NavTree()\Type) : GadPos + 1 : EndIf ;/ company
    If NavTree()\Type = #NavTree_Site : AddGadgetItem(#Gad_NavTree,-1,TreeString,ImageID(#Image_Treeview_Factory),NavTree()\Type) : GadPos + 1 : EndIf ;/ Site
    If NavTree()\Type = #NavTree_Group : AddGadgetItem(#Gad_NavTree,-1,TreeString,ImageID(#Image_TreeView_Group),NavTree()\Type) : GadPos + 1 : EndIf ;/ Group
    If NavTree()\Type = #NavTree_Roll
      AddGadgetItem(#Gad_NavTree,-1,TreeString,ImageID(#Image_Roll),NavTree()\Type)
      GadPos + 1 
      If NavTree()\RollID = System\ForceSelectRollID : GadState.i = GadPos : EndIf
    EndIf
  Next 
  SetGadgetState(#Gad_NavTree,GadState-1)
  SetGadgetText(#Gad_Welcome_ClientName,System\Database_Company)

EndProcedure

Procedure.i Report_Add_GroupDetail(GroupID.i,Filter.s = "")
  Protected GroupName.S, RollCount.i, ResultS.S, Length.i, VarAmount.f, OnRow.i
  Protected RollName.S, RollManufacturer.S, RollScreen.S, RollVolume.S,RollCapacity.S,RollVariance.S, SuitI.i, Suitability.s, DateI.i, LastReadDate.s, RollDepth.s
  Protected SiteName.S, GroupCount.i, MyLoop.i, RollID.i, TempI.i, Comment.s
  Protected Count.i, SQL.s

  SQL.s = "Select ID, Name, Manufacturer, Screencount, Volume, Capacity, Variance, Suitability, LastReadingDate, Comments, Current_Depth From AMS_Roll_Master Where GroupID = "+Str(GroupID)
  ;/               0     1        2           3          4        5          6           7             8             9   
  
  SQL.s + " " +Filter
  SQL.s + ";"
  
  DatabaseQuery(#Database_Reporting, SQL)
  While NextDatabaseRow(#Database_Reporting)
    ResultS = ""
    ;/ Populate initial readings from Roll Master database
    Count + 1
    RollID = GetDatabaseLong(#Database_Reporting, 0) ;/ Read rollID
    
    ;/ Store RollID in linked list, for drilling into
    AddElement(ReportLine_RollID())
    ReportLine_RollID() = RollID
    
    RollName = GetDatabaseString(#Database_Reporting, 1)
    
    TempI = GetDatabaseLong(#Database_Reporting, 2) ;/ Manufacturer
    
    RollManufacturer = Get_Manufacturer_Text(TempI)
    Debug "*** Roll Manu - ID: "+Str(TempI) +" - Test: "+RollManufacturer
    
    RollScreen = GetDatabaseString(#Database_Reporting, 3)
    RollVolume = GetDatabaseString(#Database_Reporting, 4)
    RollCapacity = Str(Val(GetDatabaseString(#Database_Reporting, 5)))
    RollVariance = Str(Val(GetDatabaseString(#Database_Reporting, 6)))
    SuitI = GetDatabaseLong(#Database_Reporting,7)
    Suitability = Get_Suitability_Text(SuitI)

    DateI = GetDatabaseLong(#Database_Reporting,8)
    Comment = GetDatabaseString(#Database_Reporting,9)
    ;Comment = Left(Comment,24)
    LastReadDate = UnitConversion_Date(DateI)
    
    RollDepth = GetDatabaseString(#Database_Reporting, 10)
    
    If IniSwitch_ReportDepths = 1
      RollManufacturer = RollDepth
    EndIf
    
    ;    Debug RollVolume+" - "+RollCapacity
    If RollVolume <> "0.0" And RollCapacity = "0.0" : RollCapacity = "100.0" : EndIf
    If System\DecimalNotation = 1 ;/ Comma
      RollVolume = ReplaceString(RollVolume,".",",")
      RollVariance = ReplaceString(RollVariance,".",",")
      RollCapacity = ReplaceString(RollCapacity,".",",")
    EndIf
        
    ResultS = RollName + Chr(10) + RollManufacturer + Chr(10) + RollScreen + Chr(10) + RollVolume + Chr(10) + RollVariance+"%" + Chr(10) + RollCapacity+"%" + Chr(10) + Suitability + Chr(10) + LastReadDate + Chr(10) + Comment
    AddGadgetItem(#Gad_Report_ReportList,-1,ResultS)
    SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(255,255,200),-1)
    
  Wend
  FinishDatabaseQuery(#Database_Reporting)
  
  ProcedureReturn Count 
  
EndProcedure ;/ DatabaseQuery(0, "Select ID, Name, GroupID From AMS_Roll_Master Order by Name, Name+'0';")
Procedure Redraw_Report(SiteID.l,GroupID.l) ;/ Must pass selected Group - Show all rolls assigned to that particaulr Group, along with Roll Statistics
  Protected GroupName.s, RollCount.i, ResultS.s, Length.i, VarAmount.f, OnRow.i
  Protected RollName.s, RollManufacturer.s, RollScreen.s, RollVolume.s, RollCapacity.s, RollVariance.s, RollDepth.s
  Protected SiteName.s, GroupCount.i, MyLoop.i, RollID.i, TempI.i
  Protected Filter.s, FilterI.i, FirstCheck.i, SQL.s, GroupI.i
  Protected Count.i, LastReadDate.s, DateI.i, SuitI.i, Suitability.s, Txt.s
  Protected NewList Temp_Groups.ID_Name()
  
  System\Report_Type.i = GetGadgetState(#Gad_Report_Style_Combo)
  ClearList(Report_FlatList())
  
  FilterI = GetGadgetState(#Gad_Report_Preset_Combo)+1
  Filter = ""
  If FilterI > 1 ;/ so not 'Show all'
    FirstElement(Report_PresetList())
    For Myloop = 2 To FilterI
      NextElement(Report_PresetList())
    Next
    
    ;Filter = " And " + Database_StringQuery("Select SQL from AMS_ReportPresets Where ID = "+Str(FilterI))  ;/DNT
    Filter = " And (" + Report_PresetList()\SQL  ;/DNT
    Filter = ReplaceString(Filter,"/DATE/",Str(Date()))  ;/DNT
    Filter = ReplaceString(Filter,"/VAR_GOOD/",Str(System\Settings_Variance_Good)) ;/DNT
    Filter = ReplaceString(Filter,"/VAR_BAD/",Str(System\Settings_Variance_Bad))   ;/DNT
    Filter = ReplaceString(Filter,"/CAP_GOOD/",Str(System\Settings_Capacity_Good)) ;/DNT
    Filter = ReplaceString(Filter,"/CAP_BAD/",Str(System\Settings_Capacity_Bad))   ;/DNT
    Filter + ")"
  EndIf 

  Select GetGadgetState(#Gad_Report_SortBy_Combo)
    Case #Report_Sort_RollID
      Filter + " Order by Name, Name+0"  ;/DNT
    Case #Report_Sort_Capacity
      Filter + " Order By Capacity"  ;/DNT
    Case #Report_Sort_Manufacturer
      Filter + " Order By Manufacturer" ;/DNT
    Case #Report_Sort_ReadingDate
      Filter + " Order By LastReadingDate" ;/DNT
    Case #Report_Sort_Screen
      Filter + " Order By Screencount" ;/DNT
    Case #Report_Sort_Variance
      Filter + " Order By Variance" ;/DNT
    Case #Report_Sort_Volume
      Filter + " Order By Volume" ;/DNT
    Case #Report_Sort_Suitability
      Filter + " Order By Suitability" ;/DNT
  EndSelect

  If GetGadgetState(#Gad_Report_SortDirection_Combo) = 0
    Filter + " Asc" ;/DNT
  Else
    Filter + " Desc" ;/DNT
  EndIf

  OpenDatabase(#Database_Reporting,DatabaseFile,"","",#PB_Database_SQLite) ;/ Site queries
  
  ;/ Query Database for Group Information
  
  ClearGadgetItems(#Gad_Report_ReportList)
  ClearList(ReportLine_RollID())
  
  System\Last_Drawn_Report_GroupId = GroupID
  System\Last_Drawn_Report_SiteID = SiteID
  
  System\ReportLines_Total = 0
  System\ReportLines_Filtered = 0
  FirstCheck.i = 0

  ;/ Get gadget Name From Database
  If GroupID > 0 ;/ single Group selected
    GroupName.S = Database_StringQuery("Select GroupName from AMS_Groups Where ID = "+Str(GroupID))
    RollCount = Database_CountQuery("Select Count(*) from AMS_Roll_Master Where GroupID = "+Str(GroupID),#PB_Compiler_Line)
    System\ReportLines_Total + RollCount
    
    If System\Report_Type.i = 0 ;/ Grouped
      
      AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_Groupname)+":"+Chr(10)+GroupName)
      SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(220,210,210),-1)
      AddElement(ReportLine_RollID())
      
      AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_Rollcount)+":"+Chr(10)+Str(RollCount))
      SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(240,230,230),-1)
      AddElement(ReportLine_RollID())
    Else
      
    EndIf
    
    Txt.s = tTxt(#Str_RollID)+Chr(10)
    If IniSwitch_ReportDepths = 0
      Txt + tTxt(#Str_Manufacturer)+Chr(10)
    Else
      Txt + tTxt(#Str_Depth)+Chr(10)
    EndIf
    Txt + System\Settings_Screen_UnitMask+Chr(10)+System\Settings_Volume_UnitMask
    Txt + Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity)+Chr(10)+tTxt(#Str_Suitability)+Chr(10)+tTxt(#Str_Lastprofiled)+Chr(10)+"Comment1"
    AddGadgetItem(#Gad_Report_ReportList,-1,Txt) 
    
    SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(250,240,150),-1)
    AddElement(ReportLine_RollID())
    
    System\ReportLines_Filtered + Report_Add_GroupDetail(GroupID,Filter)
    SetGadgetText(#Gad_Report_Counts_Text," "+"- "+tTxt(#Str_Showing)+": "+Str(System\ReportLines_Filtered)+" "+tTxt(#Str_of)+": "+Str(System\ReportLines_Total))
    
  Else ;/ must be Site instead
    SiteName.S = Database_StringQuery("Select NAME from AMS_Sites Where ID = "+Str(SiteID))
    GroupCount = Database_CountQuery("Select Count(*) from AMS_Groups Where SiteID = "+Str(SiteID),#PB_Compiler_Line)
    AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_Site)+":"+Chr(10)+SiteName)
    AddElement(ReportLine_RollID())
    SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(220,210,240),-1)
    AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_Groupcount)+":"+Chr(10)+Str(GroupCount))
    AddElement(ReportLine_RollID())
    SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(200,190,220),-1)
    AddGadgetItem(#Gad_Report_ReportList,-1,"")
    AddElement(ReportLine_RollID())
    
    If System\Report_Type = 0 ;/ Grouped
      ;/ populate Group list
      ClearList(Temp_Groups())
      
      DatabaseQuery(#Database_Reporting, "Select ID, GroupName From AMS_Groups Where SiteID = "+Str(SiteID)+";")
      While NextDatabaseRow(#Database_Reporting)
        AddElement(Temp_Groups())
        Temp_Groups()\ID = GetDatabaseLong(#Database_Reporting, 0)
        Temp_Groups()\Text = GetDatabaseString(#Database_Reporting, 1)
      Wend
      FinishDatabaseQuery(#Database_Reporting)
      
      ForEach Temp_Groups()
        ;        System\ReportLines_Total + Database_CountQuery("Select Count(*) from AMS_Roll_Master Where GroupID = "+Str(Temp_Groups()\ID)+";",#PB_Compiler_Line)
        RollCount = Database_CountQuery("Select Count(*) from AMS_Roll_Master Where GroupID = "+Str(Temp_Groups()\ID)+Filter,#PB_Compiler_Line)
        System\ReportLines_Total + Database_CountQuery("Select Count(*) from AMS_Roll_Master Where GroupID = "+Str(Temp_Groups()\ID),#PB_Compiler_Line)
        
        If RollCount > 0 ;/ Don't want to show empty groups?
          
          AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_Groupname)+":"+Chr(10)+Temp_Groups()\Text)
          AddElement(ReportLine_RollID())
          SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(220,210,210),-1)
          
          AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_Rollcount)+":"+Chr(10)+Str(RollCount))
          AddElement(ReportLine_RollID())
          SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(240,230,230),-1)
          
          Txt.s = tTxt(#Str_RollID)+Chr(10)
          If IniSwitch_ReportDepths = 0
            Txt + tTxt(#Str_Manufacturer)+Chr(10)
          Else
            Txt + tTxt(#Str_Depth)+Chr(10)
          EndIf
          Txt + System\Settings_Screen_UnitMask+Chr(10)+System\Settings_Volume_UnitMask
          Txt + Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity)+Chr(10)+tTxt(#Str_Suitability)+Chr(10)+tTxt(#Str_Lastprofiled)+Chr(10)+"Comment1"
          AddGadgetItem(#Gad_Report_ReportList,-1,Txt) 
          
          
          ;          AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_RollID)+Chr(10)+tTxt(#Str_Manufacturer)+Chr(10)+System\Settings_Screen_UnitMask+Chr(10)+System\Settings_Volume_UnitMask+Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity)+Chr(10)+tTxt(#Str_Suitability)+Chr(10)+tTxt(#Str_Lastreading)+Chr(10)+"Comment");/TODO
          AddElement(ReportLine_RollID())
          SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(250,240,150),-1)
          
          System\ReportLines_Filtered + Report_Add_GroupDetail(Temp_Groups()\ID,Filter)
          
          If System\Report_Type = 0 ;/ Grouped
            
            AddGadgetItem(#Gad_Report_ReportList,-1,"")
            AddElement(ReportLine_RollID())
            ;AddGadgetItem(#Gad_Report_ReportList,-1,"")
            ;AddElement(ReportLine_RollID())
          EndIf
          
        EndIf
        ;FinishDatabaseQuery(1)
      Next
    Else
      ;/ *************************************** Flat Report *******************************************
      
      SQL.s = "Select Count(*) From (Select AMS_Roll_Master.Name From AMS_Roll_Master,AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(SiteID)+")" ;/DNT
      SQL.s + " "+";"
      System\ReportLines_Total = Database_CountQuery(SQL,#PB_Compiler_Line)
      
      SQL.s = "Select Count(*) From (Select AMS_Roll_Master.Name From AMS_Roll_Master,AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(SiteID) ;/DNT
      ;      SQL.s = "Select Count(*)  AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(SiteID)
      SQL.s + " " +Filter
      SQL.s + " "+")"+";"
      System\ReportLines_Filtered = Database_CountQuery(SQL,#PB_Compiler_Line)
      
      SQL.s = "Select AMS_Roll_Master.ID, AMS_Roll_Master.Name, AMS_Roll_Master.Manufacturer, AMS_Roll_Master.Screencount, AMS_Roll_Master.Volume, AMS_Roll_Master.Capacity, AMS_Roll_Master.Variance, AMS_Roll_Master.Suitability, AMS_Roll_Master.LastReadingDate, AMS_Groups.GroupName, AMS_Roll_Master.Current_Depth From AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(SiteID)
      SQL.s + " " +Filter
      SQL.s + " "+";"
      
      ;/ Add Report Header
      AddElement(ReportLine_RollID())
      
      Txt.s = tTxt(#Str_RollID)+Chr(10)
      If IniSwitch_ReportDepths = 0
        Txt + tTxt(#Str_Manufacturer)+Chr(10)
      Else
        Txt + tTxt(#Str_Depth)+Chr(10)
      EndIf
      Txt + System\Settings_Screen_UnitMask+Chr(10)+System\Settings_Volume_UnitMask
      Txt + Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity)+Chr(10)+tTxt(#Str_Suitability)+Chr(10)+tTxt(#Str_Lastprofiled)+Chr(10)+"Comment1"
      AddGadgetItem(#Gad_Report_ReportList,-1,Txt) 
      
      ;      AddGadgetItem(#Gad_Report_ReportList,-1,tTxt(#Str_RollID)+Chr(10)+tTxt(#Str_Manufacturer)+Chr(10)+System\Settings_Screen_UnitMask+Chr(10)+System\Settings_Volume_UnitMask+Chr(10)+tTxt(#Str_Variance)+Chr(10)+tTxt(#Str_Capacity)+Chr(10)+tTxt(#Str_Suitability)+Chr(10)+tTxt(#Str_Lastreading)+Chr(10)+tTxt(#Str_Group))
      SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(250,240,150),-1)
      
      ;/ Add Report data
      DatabaseQuery(#Database_Reporting, SQL)
      While NextDatabaseRow(#Database_Reporting)
        ResultS = ""
        ;/ Populate initial readings from Roll Master database
        Count + 1
        RollID = GetDatabaseLong(#Database_Reporting, 0) ;/ Read rollID
        
        ;/ Store RollID in linked list, for drilling into
        AddElement(ReportLine_RollID())
        ReportLine_RollID() = RollID
        
        RollName = GetDatabaseString(#Database_Reporting, 1)
        
        TempI = GetDatabaseLong(#Database_Reporting, 2)
        
        ;/ Read in Manufacturer reference
        ;        If TempI > 0
        RollManufacturer = Get_Manufacturer_Text(TempI)
        ;SelectElement(ManufacturerList(),TempI-1) : RollManufacturer = ManufacturerList()\Text
        ;Else
        ;  RollManufacturer = ""
        ;EndIf
        
        RollScreen = GetDatabaseString(#Database_Reporting, 3)
        RollVolume = GetDatabaseString(#Database_Reporting, 4)
        RollCapacity = GetDatabaseString(#Database_Reporting, 5)
        RollVariance = GetDatabaseString(#Database_Reporting, 6)
        SuitI = GetDatabaseLong(#Database_Reporting,7)
        Suitability = Get_Suitability_Text(SuitI)
        DateI = GetDatabaseLong(#Database_Reporting,8)
        LastReadDate = UnitConversion_Date(DateI)
        GroupName = GetDatabaseString(#Database_Reporting,9)
        RollDepth = GetDatabaseString(#Database_Reporting, 10)
        
        If IniSwitch_ReportDepths = 1
          RollManufacturer = RollDepth
        EndIf
        
        If RollVolume <> "0.0" And RollCapacity = "0.0" : RollCapacity = "100.0" : EndIf
        If System\DecimalNotation = 1 ;/ Comma
          RollVolume = ReplaceString(RollVolume,".",",")
          RollVariance = ReplaceString(RollVariance,".",",")
          RollCapacity = ReplaceString(RollCapacity,".",",")
        EndIf

        ResultS = RollName + Chr(10) + RollManufacturer + Chr(10) + RollScreen + Chr(10) + RollVolume + Chr(10) + RollVariance+"%" + Chr(10) + RollCapacity+"%"
        ResultS + Chr(10) + Suitability + Chr(10) + LastReadDate + Chr(10) + GroupName
        AddGadgetItem(#Gad_Report_ReportList,-1,ResultS)
        SetGadgetItemColor(#Gad_Report_ReportList,CountGadgetItems(#Gad_Report_ReportList)-1,#PB_Gadget_BackColor,RGB(255,255,200),-1)
        
      Wend
      FinishDatabaseQuery(#Database_Reporting)
    EndIf
    
    SetGadgetText(#Gad_Report_Counts_Text," "+"- "+tTxt(#Str_Showing)+":"+" "+Str(System\ReportLines_Filtered)+" "+tTxt(#Str_of)+Str(System\ReportLines_Total))
    
  EndIf
  
  CloseDatabase(#Database_Reporting)
  
  System\TimeStamp_Site = Database_GetSiteTimeStamp(SiteID)
  
EndProcedure

Procedure.S InputRequesterEx(Title$,Message$,DefaultString$)
  Protected Result$, Window, String, OK, Cancel, event
  Window = OpenWindow(#PB_Any,0,0,300,95,Title$,#PB_Window_WindowCentered| #PB_Window_SystemMenu ,WindowID(#Window_Main))
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  If Window
    StickyWindow(Window,1)
    TextGadget(#PB_Any,10,10,280,20,Message$)
    String = StringGadget(#PB_Any,10,30,280,20,DefaultString$): SetActiveGadget(String)
    OK     = ButtonGadget(#PB_Any,60,60,80,25,tTxt(#Str_OK),#PB_Button_Default)
    Cancel = ButtonGadget(#PB_Any,150,60,80,25,tTxt(#Str_Cancel))
    Repeat
      event = WaitWindowEvent()
      If event = #PB_Event_Gadget
        If EventGadget() = OK
          Result$ = GetGadgetTextMac(String)
          Break
        ElseIf EventGadget() = Cancel
          Result$ = ""
          Break
        EndIf
      EndIf
      If event = #PB_Event_CloseWindow
        Result$ = ""
        Break
      EndIf
      If GetKeyState_(#VK_RETURN) > 1
        Result$ = GetGadgetTextMac(String)
        Break
      EndIf
    ForEver
    CloseWindow(Window)
  EndIf
  ProcedureReturn Result$
EndProcedure

Procedure NavTree_SetToRollID(RollID.i)
  Debug "Setting Navtree to RollID: "+Str(RollID)
  ForEach NavTree()
    If NavTree()\RollID = RollID
      SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
    EndIf
  Next
  
EndProcedure
Procedure NavTree_SetToGroupID(GroupID.i)
  Debug "Setting Navtree to GroupID: "+Str(GroupID)
  ForEach NavTree()
    If NavTree()\GroupID = GroupID
      SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
      ProcedureReturn 
    EndIf
  Next
  
EndProcedure
Procedure NavTree_SetToSiteID(SiteID.i)
  Debug "Setting Navtree to SiteID: "+Str(SiteID)
  ForEach NavTree()
    If NavTree()\SiteID = SiteID
      SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
      ProcedureReturn 
    EndIf
  Next
EndProcedure
Procedure Refresh_Suitability_List()
  ;/ Populate Suitability list
  ClearList(SuitabilityList())
  
  AddElement(SuitabilityList())
  SuitabilityList()\ID = 0
  SuitabilityList()\Text = "*"+tTxt(#Str_Notset)+"*"
  SuitabilityList()\Count = 0
  
  If DatabaseQuery(#Databases_Master,"Select ID,Description From AMS_Suitability") ;/ There's a rolltype also in here, future releases might differentiate between Anilox / Gravure / Plate / Stylus
    While NextDatabaseRow(#Databases_Master)  
      AddElement(SuitabilityList())
      SuitabilityList()\ID = GetDatabaseLong(#Databases_Master,0) 
      SuitabilityList()\Text = GetDatabaseString(#Databases_Master,1) 
      SuitabilityList()\Count = ListIndex(SuitabilityList())
    Wend 
    FinishDatabaseQuery(#Databases_Master)
    
    ;/ refresh list on Roll detail screen
    If IsGadget(#Gad_Rollinfo_Suitability_String)
      ClearGadgetItems(#Gad_Rollinfo_Suitability_String)
      ;AddGadgetItem(#Gad_Rollinfo_Suitability_String,-1,"*"+tTxt(#Str_Notset)+"*")
      ForEach SuitabilityList()
        AddGadgetItem(#Gad_Rollinfo_Suitability_String,-1,SuitabilityList()\Text)
      Next
    EndIf
    
    ;/ Refresh list on settings \ suitability screen.
    If IsGadget(#Settings_Suitability_List)
      ClearGadgetItems(#Settings_Suitability_List)
      ForEach SuitabilityList()
        If ListIndex(SuitabilityList()) > 0
          AddGadgetItem(#Settings_Suitability_List,-1,SuitabilityList()\Text)  
        EndIf
        
      Next
    EndIf
  EndIf
  
EndProcedure
Procedure Refresh_Site_List()
  ClearList(SiteList())
  If DatabaseQuery(#Databases_Master,"Select ID,Name From AMS_Sites") ;/
    While NextDatabaseRow(#Databases_Master)  
      AddElement(SiteList())
      SiteList()\ID = GetDatabaseLong(#Databases_Master,0) 
      SiteList()\Text = GetDatabaseString(#Databases_Master,1) 
      SiteList()\Count = ListIndex(SiteList())
    Wend 
    FinishDatabaseQuery(#Databases_Master)
  EndIf 
  
EndProcedure

Procedure Refresh_Manufacturer_List()
  ;/ Populate Manufacturer list
  ClearList(ManufacturerList())
  ;  AddElement(ManufacturerList())
  ;  ManufacturerList()\ID = 0
  ;  ManufacturerList()\Text = GetDatabaseString(#Databases_Master,1) 
  
  AddElement(ManufacturerList())
  ManufacturerList()\ID = 0
  ManufacturerList()\Text = "*"+tTxt(#Str_Unknown)+"*"
  ManufacturerList()\Count = 0
  
  If DatabaseQuery(#Databases_Master,"Select ID,Name From AMS_Manufacturers") ;/ 
    While NextDatabaseRow(#Databases_Master)  
      AddElement(ManufacturerList())
      ManufacturerList()\ID = GetDatabaseLong(#Databases_Master,0) 
      ManufacturerList()\Text = GetDatabaseString(#Databases_Master,1) 
      ManufacturerList()\Count = ListIndex(ManufacturerList())
      ;Debug "*** Manufacturer: "+ManufacturerList()\Text
    Wend 
    FinishDatabaseQuery(#Databases_Master)
    
    ;/ Refresh list on roll detail screen.
    If IsGadget(#Gad_Rollinfo_Manufacturer_String)
      ;AddGadgetItem(#Gad_Rollinfo_Manufacturer_String,-1,"*"+ tTxt(#Str_Unknown) +"*") ;/DNT
      ClearGadgetItems(#Gad_Rollinfo_Manufacturer_String)
      ForEach ManufacturerList()
        AddGadgetItem(#Gad_Rollinfo_Manufacturer_String,-1,ManufacturerList()\Text)
      Next
    EndIf
    
    If IsGadget(#Settings_Manufacturer_List)
      ClearGadgetItems(#Settings_Manufacturer_List)
      ForEach ManufacturerList()
        If ListIndex(ManufacturerList()) > 0
          AddGadgetItem(#Settings_Manufacturer_List,-1,ManufacturerList()\Text)  
        EndIf
      Next
    EndIf

  EndIf 
EndProcedure
Procedure Refresh_Presets_List()
  ;/ Populate Manufacturer list
  ClearList(Report_PresetList())
 
  If DatabaseQuery(#Databases_Master,"Select ID, Name, SQL From AMS_ReportPresets") ;/ 
    While NextDatabaseRow(#Databases_Master)  
      AddElement(Report_PresetList())
      Report_PresetList()\ID = GetDatabaseLong(#Databases_Master,0) 
      Report_PresetList()\Name = GetDatabaseString(#Databases_Master,1) 
      Report_PresetList()\SQL.s = GetDatabaseString(#Databases_Master,2) 
    Wend 
    FinishDatabaseQuery(#Databases_Master)
    
    If IsGadget(#Gad_Report_Preset_Combo)
      ClearGadgetItems(#Gad_Report_Preset_Combo)
      ForEach Report_PresetList()
        AddGadgetItem(#Gad_Report_Preset_Combo,-1,Report_PresetList()\Name)
      Next
      SetGadgetState(#Gad_Report_Preset_Combo,0)
    EndIf
  EndIf 
EndProcedure
Procedure Refresh_Group_List(SiteID.i=0) ;/ refreshes combobox on Rollinfo window
  ;/ Populate Group list
  Debug "Refreshing Groups!"
  ClearList(Database_GroupList())

  If DatabaseQuery(#Databases_Master,"Select ID, GroupName From AMS_Groups") ;/ 
    While NextDatabaseRow(#Databases_Master)  
      AddElement(Database_GroupList())
      Database_GroupList()\ID   = GetDatabaseLong(#Databases_Master,0) 
      Database_GroupList()\Text = GetDatabaseString(#Databases_Master,1) 
    Wend 
    FinishDatabaseQuery(#Databases_Master)
    
    ;If IsGadget(#Gad_Rollinfo_Group_Combo)
      ;ClearGadgetItems(#Gad_Rollinfo_Group_Combo)
     ;ForEach Database_GroupList()
     ;   AddGadgetItem(#Gad_Rollinfo_Group_Combo,-1,Database_GroupList()\Text)
    ;  Next
   ; EndIf
 EndIf 

EndProcedure

Procedure Language_Set(Language.s="English")
  Protected MyLoop.i, LanguageNum.i
  
  If ListSize(Langmaster()) = 0
    MessageRequester("Error","No Language Files loaded, but still trying to set - Exitting.")
    End
  EndIf
  
  
  ForEach LangMaster()
    LanguageNum = ListIndex(Langmaster())
    If LangMaster()\Language = Language
      Break
    EndIf
  Next
  
  ;  SelectElement(LangMaster(),LanguageNum)
  System\Language_Current_File = LanguagesDirectory+LangMaster()\FileName
  System\Language_Current_Element.i = ListIndex(LangMaster())
  
  For MyLoop = 1 To LangMaster()\StringCount
    tTxt(Myloop-1) = LangMaster()\String[MyLoop]
  Next
  System\Font_Name = LangMaster()\FontName
  System\Font_Size_XS = LangMaster()\FontsizeXS
  System\Font_Size_S = LangMaster()\FontsizeS
  System\Font_Size_M = LangMaster()\FontsizeM
  System\Font_Size_L = LangMaster()\FontsizeL
  System\Font_Size_XL = LangMaster()\FontsizeXL
  System\CSVDelimiter = Langmaster()\CSVDelimiter
  System\DecimalNotation = Langmaster()\DecimalNotation
  
  Init_Fonts()
  Refresh_Manufacturer_List()
  Refresh_Suitability_List()
  System\Showing_RollID = -1
  System\Last_Drawn_Roll = -1
EndProcedure

Procedure Language_Parse_Files()
  Protected DirectoryID.i, Stringcount.i, FilesLoaded.i, Version.i, MasterCount.i, MyLoop.i, LoopFrom.i, NewString.s
  Debug "*** Parsing Language Files ***"
  
  ;/ Populate Langmaster List with filenames in Languages directory
  directoryID = ExamineDirectory(#PB_Any,LanguagesDirectory,"*.db")
  If directoryID
    While NextDirectoryEntry(directoryID)
      AddElement(Langmaster())
      LangMaster()\FileName = DirectoryEntryName(directoryID)
      ;Debug LangMaster()\FileName
    Wend
    FinishDirectory(directoryID)
  EndIf  
  
  ;/ If no Language files are found, show error and end
  If ListSize(LangMaster()) = 0
    MessageRequester("Error", "Language files are missing, exitting.")
    End
  EndIf

  ;/ Check version of all language database files and update if necessary.
  ForEach LangMaster()
    ;Debug "Loading: "+LangMaster()\FileName
    ;MessageRequester("Msg","Loading: "+LangMaster()\FileName)
    If OpenDatabase(#Databases_Language,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
      DatabaseQuery(#Databases_Language,"Select Version from AMS_Language_Master;")

      NextDatabaseRow(#Databases_Language)
      Version =  GetDatabaseLong(#Databases_Language,0)
      Debug LangMaster()\FileName+" Loaded - Version: "+Str(Version)
      
      Select Version
          
        Case 0 
          ;/ No Version field in Table - Add Version Field, Delimiter Type & Decimal notation
          Database_Update(#Databases_Language,"ALTER TABLE AMS_Language_Master ADD Column [Version] Int;",#PB_Compiler_Line) ;/DNT
          Database_Update(#Databases_Language,"ALTER TABLE AMS_Language_Master ADD Column [CSVDelimiter] Char;",#PB_Compiler_Line) ;/DNT
          Database_Update(#Databases_Language,"ALTER TABLE AMS_Language_Master ADD Column [DecimalNotation] Char;",#PB_Compiler_Line) ;/DNT
          
          ;/ Insert default values
          Database_Update(#Databases_Language,"Update AMS_Language_Master Set Version = 1, CSVDelimiter = '0', DecimalNotation = '0';",#PB_Compiler_Line)
          Debug "***** Updated Language File version "+LangMaster()\Language+" *****"
        Case 1

      EndSelect       
      FinishDatabaseQuery(#Databases_Language)
      CloseDatabase(#Databases_Language)
    EndIf
    
  Next
  
  ;/ *** Align Database sizes, so that all databases have the same quantity of records as the master (English) database
  ForEach LangMaster()
    OpenDatabase(#Databases_Language,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
    DatabaseQuery(#Databases_Language,"Select Count(*) from AMS_Language_Data;")
    NextDatabaseRow(#Databases_Language)
    LangMaster()\StringCount = GetDatabaseLong(#Databases_Language,0)
    If UCase(LangMaster()\FileName) = UCase("English.DB")
      MasterCount = LangMaster()\StringCount
    EndIf
    CloseDatabase(#Databases_Language)
  Next
  ForEach LangMaster()
    If LangMaster()\StringCount < MasterCount
      OpenDatabase(#Databases_Language,LanguagesDirectory+"English.db","","",#PB_Database_SQLite)
      OpenDatabase(#Databases_NT_Count,LanguagesDirectory+ LangMaster()\FileName,"","",#PB_Database_SQLite)
      LoopFrom = LangMaster()\StringCount
      If Loopfrom = 0 : LoopFrom = 1 : EndIf 
      For Myloop = LoopFrom+1 To MasterCount
        DatabaseQuery(#Databases_Language,"Select String from AMS_Language_Data Where ID = "+Str(MyLoop)+";")
        NextDatabaseRow(#Databases_Language)
        NewString.s = GetDatabaseString(#Databases_Language,0)
        
        Database_Update(#Databases_NT_Count,"Insert Into AMS_Language_Data (String) Values ('"+FormatTextMac(NewString)+"');",#PB_Compiler_Line)
        Debug "Added string to Database: "+LangMaster()\FileName
      Next
      CloseDatabase(#Databases_Language) : CloseDatabase(#Databases_NT_Count)
    EndIf
  Next
  ;/ ***
  
  ;/ Load Language data
  ForEach LangMaster()
    ;Debug "Loading: "+LangMaster()\FileName
    ;MessageRequester("Msg","Loading: "+LangMaster()\FileName)
    If OpenDatabase(#Databases_Language,LanguagesDirectory+LangMaster()\FileName,"","",#PB_Database_SQLite)
      
      ;/ Load master data
      ;/ Populate initial table

      DatabaseQuery(#Databases_Language,"Select Language, FontName, FontsizeXS, FontsizeS, FontsizeM, FontsizeL, FontsizeXL, Comment, CSVDelimiter, DecimalNotation from AMS_Language_Master;")
      While NextDatabaseRow(#Databases_Language)
        LangMaster()\Language.s = GetDatabaseString(#Databases_Language,0)
        LangMaster()\FontName.s = GetDatabaseString(#Databases_Language,1)
        LangMaster()\FontsizeXS.i = GetDatabaseLong(#Databases_Language,2)
        LangMaster()\FontsizeS.i = GetDatabaseLong(#Databases_Language,3)
        LangMaster()\FontsizeM.i = GetDatabaseLong(#Databases_Language,4)
        LangMaster()\FontsizeL.i = GetDatabaseLong(#Databases_Language,5)
        LangMaster()\FontsizeXL.i = GetDatabaseLong(#Databases_Language,6)
        LangMaster()\Comment.s = GetDatabaseString(#Databases_Language,7)
        LangMaster()\CSVDelimiter = GetDatabaseLong(#Databases_Language,8)
        LangMaster()\DecimalNotation = GetDatabaseLong(#Databases_Language,9)
        
        If Langmaster()\Language = System\Settings_Language
          System\CSVDelimiter = LangMaster()\CSVDelimiter
          System\DecimalNotation = LangMaster()\DecimalNotation
        EndIf
      Wend
      FinishDatabaseQuery(#Databases_Language)
      
      
      ;/ Load Strings
      DatabaseQuery(#Databases_Language,"Select String, Override_String from AMS_Language_Data;")
      StringCount = 0
      While NextDatabaseRow(#Databases_Language)
        StringCount + 1
        LangMaster()\String[StringCount] = GetDatabaseString(#Databases_Language,0)
        LangMaster()\String_Override[StringCount] = GetDatabaseString(#Databases_Language,1)
        If LangMaster()\String_Override[StringCount] <> ""
          LangMaster()\String[StringCount] = LangMaster()\String_Override[StringCount]
        EndIf
        
        If LangMaster()\Language.s = "English"
          ;Debug "StringCount: "+Str(Stringcount)+" = "+LangMaster()\String[StringCount]
        EndIf
        
      Wend
      ;Debug Str(Stringcount)+" strings loaded for Language: "+LangMaster()\Language.s
      LangMaster()\StringCount = StringCount
      FinishDatabaseQuery(#Databases_Language)
      CloseDatabase(#Databases_Language)
    Else
      MessageRequester("Error","Unable to open Language file!")
    EndIf
    
  Next
  ;MessageRequester("Msg","End Parse Files")
EndProcedure

Procedure.i Database_LoadSettings() ;/ Loads settings from database + Load suitability List
  Protected Code.S, DatabaseVersion.i, LocalDBFile.i, Sql.s, FileOpen.i
  ;Debug "*** Loading database Settings ***"
  ;/
  ;/ seperating into seperate queries, for ease of use, speed shouldn't be an issue.
  ;/
  ;/ SQL = "Create TABLE [AMS_Settings] ( [Version] INT,  [Language] Int,  [ScreenUnit] Int,  [LengthUnit] Int,  [VolumeUnit] Int,  [DateFormat] Int,"
  ;/ SQL + "[VarianceGood] Int, [VarianceBad] Int,  [CapacityGood] Int, [CapacityBad] Int, [Code] CHAR);" 
  ;  DatabaseQuery(#Databases_Master, "Select * from AMS_Settings;")
  
  ;/ database version is on both local & remote settings file - Code is always stored on remote file
  System\Database_Version = Database_IntQuery("Select Version from AMS_Settings;")
  Code.S = DecryptCode(Database_StringQuery("Select Code from AMS_Settings;"),"OpenWindow") ;/DNT
  If StringField(Code,1,Chr(10)) = "ARK" ;/DNT
    System\Database_Company = StringField(Code,2,Chr(10))
    System\Settings_SiteLimit = Val(StringField(Code,3,Chr(10)))
    System\Settings_RollLimit = Val(StringField(Code,4,Chr(10)))
    System\Settings_ReadingsLimit = Val(StringField(Code,5,Chr(10)))
  Else
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_Systemsettingsfailure),#PB_MessageRequester_Ok)
    System\Quit = 1
  EndIf
  
  If Multi_Site_Mode = 0
    System\Settings_Screen_Unit = Database_IntQuery("Select ScreenUnit from AMS_Settings;")
    System\Settings_Length_Unit = Database_IntQuery("Select LengthUnit from AMS_Settings;")
    System\Settings_Volume_Unit = Database_IntQuery("Select VolumeUnit from AMS_Settings;")
    System\Settings_Date_Format = Database_IntQuery("Select DateFormat from AMS_Settings;")
    System\Settings_Language.s  = Database_StringQuery("Select Language from AMS_Settings;")
    
    System\Settings_Capacity_Good = Database_IntQuery("Select CapacityGood from AMS_Settings;")
    System\Settings_Capacity_Bad = Database_IntQuery("Select CapacityBad from AMS_Settings;")
    
    System\Settings_Variance_Good = Database_IntQuery("Select VarianceGood from AMS_Settings;")
    System\Settings_Variance_Bad = Database_IntQuery("Select VarianceBad from AMS_Settings;")
    
    System\ImportPath = Database_StringQuery("Select ImportPath from AMS_Settings;")
    System\LiveMonitor = Database_IntQuery("Select Monitor from AMS_Settings;")
    
    System\DeleteAfterImport = Database_IntQuery("Select Import_Delete from AMS_Settings;")
    System\Show_Depth = Database_IntQuery("Select Show_Depth from AMS_Settings;")
    
    System\Database_Path = Database_StringQuery("Select Database_Path from AMS_LocalSettings;", #Databases_LocalSettings)
  Else ;/ is multi site
    
    ;/ read in the localised settings here
    System\Settings_Screen_Unit = Database_IntQuery("Select ScreenUnit from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Settings_Length_Unit = Database_IntQuery("Select LengthUnit from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Settings_Volume_Unit = Database_IntQuery("Select VolumeUnit from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Settings_Date_Format = Database_IntQuery("Select DateFormat from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Settings_Language.s  = Database_StringQuery("Select Language from AMS_LocalSettings;",#Databases_LocalSettings)
    
    System\Settings_Capacity_Good = Database_IntQuery("Select CapacityGood from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Settings_Capacity_Bad = Database_IntQuery("Select CapacityBad from AMS_LocalSettings;", #Databases_LocalSettings)
    
    System\Settings_Variance_Good = Database_IntQuery("Select VarianceGood from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Settings_Variance_Bad = Database_IntQuery("Select VarianceBad from AMS_LocalSettings;", #Databases_LocalSettings)
    
    System\ImportPath = Database_StringQuery("Select ImportPath from AMS_LocalSettings;", #Databases_LocalSettings)
    System\LiveMonitor = Database_IntQuery("Select Monitor from AMS_LocalSettings;", #Databases_LocalSettings)
    
    System\DeleteAfterImport = Database_IntQuery("Select Import_Delete from AMS_LocalSettings;", #Databases_LocalSettings)
    
    ;System\Database_Path = Database_StringQuery("Select Database_Path from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Default_Site = Database_IntQuery("Select Default_Site from AMS_LocalSettings;", #Databases_LocalSettings)
    System\PollingInterval = Database_IntQuery("Select Polling_Interval from AMS_LocalSettings;", #Databases_LocalSettings)
    System\DefaultOnly = Database_IntQuery("Select DefaultOnly from AMS_LocalSettings;", #Databases_LocalSettings)
    System\Show_Depth = Database_IntQuery("Select Show_Depth from AMS_LocalSettings;", #Databases_LocalSettings)
  EndIf
  
  If System\Settings_Date_Format = 0 ;/ UK
    System\Settings_Date_Mask = "DD/MM/YYYY";/DNT
  Else ;/ USA etc,.
    System\Settings_Date_Mask = "MM/DD/YYYY";/DNT
  EndIf
  
  If System\Settings_Screen_Unit = 0
    System\Settings_Screen_UnitMask = "LPI";/DNT
  Else
    System\Settings_Screen_UnitMask = "lpcm";/DNT
  EndIf
  
  If System\Settings_Length_Unit = 0
    System\Settings_Length_UnitMask = "um" ;/DNT
    System\Settings_MLength_UnitMask = "mm" ;/DNT
  Else
    System\Settings_Length_UnitMask = "thou" ;/DNT
    System\Settings_MLength_UnitMask = "In" ;/DNT
  EndIf
  
  If System\Settings_Volume_Unit = 0
    System\Settings_Volume_UnitMask = "cm3/m2" ;/DNT
  Else
    System\Settings_Volume_UnitMask = "BCM" ;/DNT
  EndIf
  
  If #Force_Single > 0 
    System\Default_Site = #Force_Single
    System\DefaultOnly = 1
  EndIf

  Refresh_Suitability_List()
  Refresh_Manufacturer_List()
  Refresh_Site_List()
  
EndProcedure
Procedure.i Database_SaveSettings() 
  
  Protected MyLoop.i, SQL.S
  ;ProcedureReturn
  ;/ Save Settings
  
  If Multi_Site_Mode = 0
    SQL.s = "Update AMS_Settings " ;/DNT
    
    SQL.s + "Set Language = '"+System\Settings_Language+"'," ;/DNT
    SQL.s + " ScreenUnit = "+Str(System\Settings_Screen_Unit.i)+"," ;/DNT
    SQL.s + " LengthUnit = "+Str(System\Settings_Length_Unit.i)+"," ;/DNT
    SQL.s + " VolumeUnit = "+Str(System\Settings_Volume_Unit.i)+"," ;/DNT
    SQL.s + " DateFormat = "+Str(System\Settings_Date_Format.i)+"," ;/DNT
    
    SQL.s + " CapacityGood = "+Str(System\Settings_Capacity_Good.i)+"," ;/DNT
    SQL.s + " CapacityBad = "+Str(System\Settings_Capacity_Bad.i)+"," ;/DNT
    
    SQL.s + " VarianceGood = "+Str(System\Settings_Variance_Good.i)+"," ;/DNT
    SQL.s + " VarianceBad = "+Str(System\Settings_Variance_Bad.i)+"," ;/DNT
    
    SQL.s + " Monitor = "+Str(System\LiveMonitor)+"," ;/DNT
    SQL.s + " ImportPath = '"+System\ImportPath+"' ," ;/DNT
    SQL.s + " Import_Delete = "+Str(System\DeleteAfterImport)+", " ;/DNT
    
    SQL.s + " Show_Depth = "+Str(System\Show_Depth) ;/DNT
    
    Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)
    
    SQL.s = "Update AMS_LocalSettings " ;/DNT
    SQL.s + "Set Database_Path = '"+System\Database_Path +"';";/DNT ;/ database path is saved in its change  procedure
    Database_Update(#Databases_LocalSettings,SQL,#PB_Compiler_Line)
  Else
    
    SQL.s = "Update AMS_LocalSettings " ;/DNT
    
    SQL.s + "Set Language = '"+System\Settings_Language+"'," ;/DNT
    SQL.s + " ScreenUnit = "+Str(System\Settings_Screen_Unit.i)+"," ;/DNT
    SQL.s + " LengthUnit = "+Str(System\Settings_Length_Unit.i)+"," ;/DNT
    SQL.s + " VolumeUnit = "+Str(System\Settings_Volume_Unit.i)+"," ;/DNT
    SQL.s + " DateFormat = "+Str(System\Settings_Date_Format.i)+"," ;/DNT
    
    SQL.s + " CapacityGood = "+Str(System\Settings_Capacity_Good.i)+"," ;/DNT
    SQL.s + " CapacityBad = "+Str(System\Settings_Capacity_Bad.i)+"," ;/DNT
    
    SQL.s + " VarianceGood = "+Str(System\Settings_Variance_Good.i)+"," ;/DNT
    SQL.s + " VarianceBad = "+Str(System\Settings_Variance_Bad.i)+"," ;/DNT
    
    SQL.s + " Monitor = "+Str(System\LiveMonitor)+"," ;/DNT
    SQL.s + " ImportPath = '"+System\ImportPath+"' ," ;/DNT
    SQL.s + " Import_Delete = "+Str(System\DeleteAfterImport)+" ," ;/DNT
    
;    SQL.s + " Database_Path = '"+System\Database_Path +"' ,";/DNT ;/ database path is saved in its change  procedure
    SQL.s + " Default_Site = "+Str(System\Default_Site)+" ," ;/DNT
    SQL.s + " Polling_Interval = "+Str(System\PollingInterval)+" ," ;/DNT
    SQL.s + " DefaultOnly = "+Str(System\DefaultOnly)+" ," ;/DNT
    SQL.s + " Show_Depth = "+Str(System\Show_Depth) ;/DNT
    Database_Update(#Databases_LocalSettings,SQL,#PB_Compiler_Line)
    
  EndIf
  
  If System\Language_Update = 1
    Language_Set(System\Settings_Language)
  EndIf
  
EndProcedure

Procedure.i MS_Check_Screen_Updates()
  Protected TimeStamp.i, CheckNavtree.i, Position.i, Type.i
  If Multi_Site_Mode = 0 : ProcedureReturn : EndIf 
  Position = GetGadgetState(#Gad_NavTree)
  If Position = -1 : Position = 0 : EndIf
  SelectElement(Navtree(),Position)
  Type = Navtree()\Type
  Select Type
    Case #NavTree_Site
      Position = Navtree()\SiteID  
    Case #NavTree_Company
      Position = Navtree()\SiteID  
    Case #NavTree_Group
      Position = Navtree()\GroupID
    Case #NavTree_Roll
      Position = Navtree()\RollID
  EndSelect

  Debug "Update?: - Panel: "+Str(System\Showing_Panel)+ ", Site: "+Str(System\Selected_Site)+ ", Group: "+Str(System\Selected_Group)+ ", Roll: "+Str(System\Selected_Roll_ID)

  Select System\Showing_Panel
            
    Case #Panel_HomeScreen
      Debug "Showing: Homescreen"
      TimeStamp = Database_GetMainTimeStamp()
      Debug "Drawn Time: "+Str(System\TimeStamp_Main) + " - Db Time: "+Str(TimeStamp)
      If TimeStamp > System\TimeStamp_Main
        Redraw_HomeScreen()
        CheckNavtree = 1
      EndIf
      
    Case #Panel_Group_List
      Debug "Showing: Group list - Group: "+Str(System\Selected_Site)
      TimeStamp = Database_GetSiteTimeStamp(System\Selected_Site)
      Debug "Drawn Time: "+Str(System\TimeStamp_Site)+" - Db Time: "+Str(TimeStamp)
      If TimeStamp > System\TimeStamp_Site
        Redraw_Report(System\Last_Drawn_Report_SiteId,System\Last_Drawn_Report_GroupId)
        CheckNavtree = 1
      EndIf

    Case #Panel_Roll_Info
      Debug "Showing: Roll Info Screen"
      If System\Selected_Roll_ID = 0 And System\Last_Drawn_Roll > 0 : System\Selected_Roll_ID = System\Last_Drawn_Roll : EndIf
      TimeStamp = Database_GetRollTimeStamp(System\Selected_Roll_ID)
      Debug "Drawn Time: "+Str(System\TimeStamp_Roll)+ " - DB Time: "+Str(TimeStamp)
      If TimeStamp > System\TimeStamp_Roll
        Redraw_RollID(System\Last_Drawn_Roll, 1)
        CheckNavtree = 1
      EndIf
  EndSelect
  
  If CheckNavtree = 1
    Message_Add("*** Redrawing Navtree ***")
    
    CheckNavtree = 0
    System\Refresh_NavTree_Type = Type
    System\Refresh_NavTreeID = Position
    Message_Add("*** Type = "+Str(Type)+" ***")
    Select Type
        
      Case #NavTree_Site
        Message_Add("*** SiteID = "+Str(Position)+" ***")        
      Case #NavTree_Company
        Message_Add("*** GroupID = "+Str(Position)+" ***")
      Case #NavTree_Group
        Message_Add("*** GroupID = "+Str(Position)+" ***")
      Case #NavTree_Roll
        Message_Add("*** RollID = "+Str(Position)+" ***")
    EndSelect
    
    
    ;System\Refresh_Roll_Information = 1
  EndIf

EndProcedure
Procedure.i MS_CheckDatabaseLocation(Reassign.i=0)
  Protected Path.s, SQL.s, Result.i,Txt.s
  ;If Multi_Site_Mode = 0 : ProcedureReturn : EndIf 
  Debug "Changing multisite database location"
  
  ;/ This procedure allows you to re-specify the database file location if it's not found when trying to load.
  ;/ There are couple of possibilities this function to be called:
  ;/  1:  If the local settings database has just been created, the path entry will be blank And will need To be specified
  ;/  2:  If the database file is no longer found on the network, which could mean:
  ;/      a)  The database file has been moved, or
  ;/      b)  The network connection needs instigating.
  ;/ just created local settings file, so will need to specify the database location.
  
  If System\Database_Path = "" Or Reassign > 0
    ;Debug 
    If Reassign = 0
      MessageRequester("Message:","The current AMS database isn't set, please specify your database ('AMS_SS.db') location on the next screen") ;/TD
    EndIf
    
    Path.s = OpenFileRequester("Please specify the database file","","AMS Database (AMS_SS.db)|AMS_SS.db",0) ;/TD
    
    If Path = "" ;/ can't do any more, must exit.
      If Reassign = 0
        End
      Else
        ProcedureReturn 1
      EndIf
    EndIf
    
    Path = GetPathPart(Path)
    If FileSize(Path+"AMS_SS.DB") = 0
      MessageRequester("Error","The AMS database was not found in the specified directory"+","+" exitting") ;/TD
      If Reassign = 0
        End
      Else
        ProcedureReturn
      EndIf
    EndIf
    
    System\Database_Path = Path
    
    ;/ Store the new database location
    SQL.s = "Update AMS_LocalSettings Set Database_Path = '"+System\Database_Path +"';";/DNT
    Database_Update(#Databases_LocalSettings,SQL,#PB_Compiler_Line)
    If IsGadget(#Settings_MultiSite_DatabasePath) : SetGadgetText(#Settings_MultiSite_DatabasePath,System\Database_Path) : EndIf
    Debug "AMS_LocalSettings Updated"
  Else
    ;/ Database location had previously been specified, but is no longer found.
    
    ;/ 1) Tell user that file wasn't found, ask if connected correctly to network.
    ;    Result = MessageRequester("Unable to open Database","Is your PC correctly connected to the network?"+Chr(10)+Chr(10)+System\Database_Path,#PB_MessageRequester_YesNo) ;/TD
    If System\Database_Path <> ""
      Txt.s = "The database wasn't found in the specified directory"+":"+Chr(10)+Chr(10)+System\Database_Path
      Txt + Chr(10)+Chr(10)+"Do you want to respecify the database location"+"?"
      Result = MessageRequester("Unable to open Database",Txt,#PB_MessageRequester_YesNo) ;/TD
      ;/ 2) If answer is no, exit program.
      If Result = #PB_MessageRequester_No
        End
      EndIf
    EndIf
  
    ;/ 3) else show a path requester for the user to re-specify 
    Path.s = OpenFileRequester("Please specify the AMS database file","","AMS Database (AMS_MS.db)|AMS_SS.db",0) ;/TD
    
    If Path = "" ;/ can't do any more, must exit.
      Debug "No Path Entered"
      End
    EndIf
    
    Path = GetPathPart(Path)
    If FileSize(Path+"AMS_SS.DB") = 0
      MessageRequester("Error","The AMS database was not found in the specified directory"+","+" exitting") ;/TD
      End
    EndIf
    
    ;/ Set Database Path
    System\Database_Path = Path
    SQL.s = "Update AMS_LocalSettings Set Database_Path = '"+System\Database_Path +"';";/DNT
    Database_Update(#Databases_LocalSettings,SQL,#PB_Compiler_Line)
    If IsGadget(#Settings_MultiSite_DatabasePath) : SetGadgetText(#Settings_MultiSite_DatabasePath,System\Database_Path) : EndIf
  EndIf
  
EndProcedure
Procedure.i DatabaseLastInsertRowId(hDB)
 Protected Result.i
  DatabaseQuery(hDB, "Select last_insert_rowid()")
  NextDatabaseRow(hDB)
  Result = GetDatabaseLong(hDB, 0)
  FinishDatabaseQuery(hdb)
  ProcedureReturn Result
 
EndProcedure
Procedure.i Database_CheckForDuplicate(SQL.S,DupeCheck.S)
  Protected Duplicate.i, Result.S

  Duplicate.i = 0
  If DatabaseQuery(#Databases_Master,SQL)
    While NextDatabaseRow(#Databases_Master)  
      Result.S = GetDatabaseString(#Databases_Master,0) 
      Debug "Checking: "+Result+" against: "+DupeCheck  ;/DNT
      If UCase(Result) = UCase(DupeCheck)
        Duplicate = 1 ;/ set duplicate flag
        Break
      EndIf 
    Wend 
  Else
    MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" "+SQL, DatabaseError())
    FinishDatabaseQuery(#Databases_Master)
    ProcedureReturn 
  EndIf 
  
  FinishDatabaseQuery(#Databases_Master)
  
  If Duplicate = 1 : ProcedureReturn 1 : EndIf
  
  ProcedureReturn 0
  
EndProcedure 
Procedure.i Database_Create_Group(SiteID.i)
  Protected Result.S, Duplicate.i, Position.i
  
  ;/ (1) Request Group Name
  Result.S = InputRequesterEx(tTxt(#Str_Creategroup)+"...", tTxt(#Str_Pleaseenternewgroupname)+":","")
  
  ;/ (2) If no entry was made, exit creation process
  If Result = "" : ProcedureReturn 0 : EndIf
  
  ;/ (3) Check if Group name already exists on site, exit if true
  Duplicate = Database_CheckForDuplicate("Select GroupName From AMS_Groups where SiteID = "+Str(SiteID),Result)  ;/DNT
  If Duplicate = 1 : MessageRequester(tTxt(#Str_Error)+" - "+tTxt(#Str_Cannotcreategroup),tTxt(#Str_Sorry)+", "+tTxt(#Str_thisgroupnamealreadyexists),#PB_MessageRequester_Ok) : ProcedureReturn 0 : EndIf
  
  ;/ (4) Create Group & set NavTree refresh flag
  Database_Update(#Databases_Master, "INSERT INTO AMS_Groups (GroupName, Type, SiteID) VALUES ('"+Result+"', '1', '"+Str(SiteID)+"')",#PB_Compiler_Line)
  
;  MessageRequester("Message:","Last Row entry is: "+Str(DatabaseLastInsertRowId(#Databases_Master)))

  Position = DatabaseLastInsertRowId(#Databases_Master)
  Debug "Group ID: "+Str(Position)
  Database_SetGroupTimeStamp(Position)
  
  System\Refresh_NavTree_Type = #NavTree_Group
  System\Refresh_NavTreeID = Position
  Refresh_Group_List(System\Selected_Site)
EndProcedure
Procedure.i Database_Rename_Group(GroupID.i)
  Protected Result.S, Duplicate.i, GroupName.S, GroupType.i, Txt.S, SiteID.i
  
  ;/ (-0) Check Group Type - 2 = Unassigned, which shouldn't be renamed.
  GroupName.S = Database_StringQuery("Select GroupName From AMS_Groups Where ID = '"+Str(GroupID)+"';")
  SiteID = Database_IntQuery("Select SiteID From AMS_Groups Where ID = '"+Str(GroupID)+"';")
  GroupType = Val(Database_StringQuery("Select Type From AMS_Groups Where ID = '"+Str(GroupID)+"';"))
  Debug "Name: "+GroupName+" - Type: "+Str(GroupType)
  ;If GroupName = tTxt(#Str_Unassigned) : MessageRequester(tTxt(#Str_Error),tTxt(#Str_Sorry)+", "+tTxt(#Str_youcannotrenametheunassignedgroup)) : ProcedureReturn : EndIf
  
  ;/ (1) Request Group Name
  Result.S = InputRequesterEx(tTxt(#Str_Renamegroup)+"...", tTxt(#Str_Pleaseenternewgroupname)+":",GroupName)
  
  ;/ (2) If no entry was made, exit creation process
  If Result = "" Or Result = GroupName: ProcedureReturn 0 : EndIf
  
  ;/ (3) Check if Group name already exists on site, exit if true
  Duplicate = Database_CheckForDuplicate("Select GroupName From AMS_Groups Where SiteID = "+Str(SiteID),Result)
  If Duplicate = 1 : MessageRequester(tTxt(#Str_Error)+" - "+tTxt(#Str_Cannotcreategroup),tTxt(#Str_Groupnamealreadyexistsforsite),#PB_MessageRequester_Ok) : ProcedureReturn 0 : EndIf
  
  ;/ (4) Create Group & set NavTree refresh flag
  Database_Update(#Databases_Master,"Update AMS_Groups SET GroupName = '"+Result+"' where ID = '" + Str(GroupID) + "';",#PB_Compiler_Line)
  Database_SetGroupTimeStamp(GroupID)
  
  System\Refresh_NavTree_Type = #NavTree_Group
  System\Refresh_NavTreeID = GroupID
  Refresh_Group_List(System\Selected_Site)
EndProcedure
Procedure.i Database_Delete_Roll(RollID.i, RollText.S) ;/ deletes the roll information from Master and Data tables *!*
  Protected Resulti.i, Position.i, GroupIP.i
  
  Debug "Database_Delete_Roll - "+Str(RollID)+" - "+RollText+"  ***************"
  
  Resulti.i = MessageRequester(tTxt(#Str_Deleteroll)+"...",tTxt(#Str_Youwilllosealldataonroll)+":"+" "+RollText+" "+"- "+tTxt(#Str_AreyouSure)+"?",#PB_MessageRequester_YesNo)
  
  If Resulti = #PB_MessageRequester_Yes
    ;/ delete Roll Master
    Position = GetGadgetState(#Gad_NavTree)
    
    Database_SetRollTimeStamp(RollID)
    Database_SetMainTimeStamp()
    
    Database_Update(#Databases_Master,"Delete from AMS_Roll_Master Where ID = '"+Str(RollID)+"';",#PB_Compiler_Line) ;/ delete roll master data
    Database_Update(#Databases_Master,"Delete from AMS_Roll_Data Where RollID = "+Str(RollID)+";",#PB_Compiler_Line) ;/ delete roll data
    Database_Update(#Databases_Master,"Delete from AMS_General_History Where RollID = "+Str(RollID)+";",#PB_Compiler_Line) ;/ delete roll history text

    Redraw_NavTree() 
    SetGadgetState(#Gad_NavTree,Position-1)
    System\Refresh_Roll_Information = 1
    
  EndIf
  
EndProcedure 
Procedure.i Database_Delete_Group(GroupID.i, ForceDelete.i = 0) ;/ *!*
  Protected Result.i, Duplicate.i, GroupName.S, GroupType.i, Txt.S, Count.i, UnassignedGroupID.i
  
  ;/ (-0) Check Group Type  <> Unassigned, which shouldn't be deleted.
  If ForceDelete = 0 ;/ normal delete
    GroupName.S = Database_StringQuery("Select GroupName From AMS_Groups Where ID = '"+Str(GroupID)+"';")
    GroupType = Database_IntQuery("Select Type From AMS_Groups Where ID = '"+Str(GroupID)+"';")

    If GroupType = 0 : MessageRequester(tTxt(#Str_Error),tTxt(#Str_Sorry)+", "+tTxt(#Str_youcannotdeletetheunassignedgroup)) : ProcedureReturn : EndIf
    
    ;/ (1) Are you sure? Sanity check.
    Count.i = Database_CountQuery("Select Count(*) from AMS_Roll_Master where GroupID = "+Str(GroupID),#PB_Compiler_Line)
    If Count.i > 0 ;/ If there's a RollID mis-match, warn user and ask if import should continue.
      Txt.S = tTxt(#Str_Theselectedgroupcurrentlyhas)+Str(Count)+" "+"roll"+"("+"s"+")"+" "+"assigned"+Chr(10)
      Txt.S + tTxt(#Str_Theserollswillbereallocatedtotheunassignedgroup)+"."+Chr(10) + Chr(10)
      Txt.S + tTxt(#Str_Continuedelete)+"?"
      Result.i = MessageRequester(tTxt(#Str_Warning)+"...",Txt.S,#PB_MessageRequester_YesNo)
      
      ;/ if no is selected, exit procedure
      If Result = #PB_MessageRequester_No
        ProcedureReturn 0
      EndIf
    EndIf
    
    ;/ Delete Group
    Debug "Roll Count on Group: "+Str(Count)
    Debug "Site ID Stored? "+Str(NavTree()\SiteID)
    ;/ (2) If there are rolls assigned to this Group, re-assign then to the unassigned pool
    UnassignedGroupID.i = Database_IntQuery("Select ID from AMS_Groups where SiteID = "+Str(NavTree()\SiteID)+" and Type "+"= "+"0") ;/DNT
    If Count > 0
      Debug "Unassigned Returned: "+Str(UnassignedGroupID)
      Database_Update(#Databases_Master,"Update AMS_Roll_Master Set GroupID = "+Str(UnassignedGroupID)+" Where GroupID = "+Str(GroupID),#PB_Compiler_Line)
    EndIf
    ;/ (3) Delete Group
    Database_Update(#Databases_Master,"Delete from AMS_Groups Where ID = '"+Str(GroupID)+"';",#PB_Compiler_Line) ;/ delete Group
    Database_SetSiteTimeStamp(NavTree()\SiteID)
    ;/ (4) Set trigger for NavTree Refresh
    System\Refresh_NavTree_Type = #NavTree_Group
    System\Refresh_NavTreeID = UnassignedGroupID
  EndIf
  If ForceDelete = 1 ;/ for site deletions, doesn't check unassigned group or warn on roll allocation
    ;/ delete rolls
    Protected NewList RollDelete.i()
    DatabaseQuery(#Databases_Master,"Select ID from AMS_Roll_Master Where GroupID = "+Str(GroupID))
    While NextDatabaseRow(#Databases_Master)
      AddElement(RollDelete.i())
      RollDelete.i() = GetDatabaseLong(#Databases_Master,0)
    Wend
    FinishDatabaseQuery(#Databases_Master)
    ForEach RollDelete()
      Database_Update(#Databases_Master,"Delete from AMS_Roll_Master Where ID = '"+Str(RollDelete())+"';",#PB_Compiler_Line) ;/ delete roll master data
      Database_Update(#Databases_Master,"Delete from AMS_Roll_Data Where RollID = "+Str(RollDelete())+";",#PB_Compiler_Line) ;/ delete roll data
      Database_Update(#Databases_Master,"Delete from AMS_General_History Where RollID = "+Str(RollDelete())+";",#PB_Compiler_Line) ;/ delete roll history text
    Next

    ;/ delete group
    Database_Update(#Databases_Master,"Delete from AMS_Groups Where ID = '"+Str(GroupID)+"';",#PB_Compiler_Line) ;/ delete Group
    Database_SetSiteTimeStamp(NavTree()\SiteID)
  EndIf
Refresh_Group_List(System\Selected_Site)
EndProcedure
Procedure.i Database_Delete_Site(SiteID.i) ;/ *!*
  Protected Result.i, Duplicate.i, SiteName.S, SiteType.i, Txt.S, Count.i, UnassignedSiteID.i
  
  SiteName.S = Database_StringQuery("Select Name From AMS_Sites Where ID = '"+Str(SiteID)+"';")
  
  Debug "Attempting to Delete a site (SiteID: "+Str(SiteID)+") - Site name: "+SiteName
  
    Count.i = Database_CountQuery("Select Count(*) from AMS_Sites;",#PB_Compiler_Line)
    If Count.i = 0 
      MessageRequester(tTxt(#Str_Sorry)+"...",tTxt(#Str_cannotdeleteastheremustbeatleastonesiteoperational),#PB_MessageRequester_YesNo)
      ProcedureReturn 0
    EndIf

  ;/ (1) Are you sure? Sanity check.
  Count.i = Database_CountQuery("Select Count(*) from AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(SiteID)+";",#PB_Compiler_Line)
  If Count.i > 0 
    Txt.S = tTxt(#Str_TheselectedSitecurrentlyhas)+" "+Str(Count)+" "+"roll"+"("+"s"+")"+" "+"assigned"+Chr(10)
    ;    Txt.S + tTxt(#Str_TheserollswillbereallocatedtotheunassignedSite)+"."+Chr(10) + Chr(10)
    Txt.S + tTxt(#Str_Continuedelete)+"?"+Chr(10) + Chr(10)
    Txt.S + "*** "+tTxt(#Str_Warning)+"! "+tTxt(#Str_Rolldatawillbepermanentlydeleted)+" ***"
    ;Txt.S + tTxt(#Str_Continuedelete)+"?"
    Result.i = MessageRequester(tTxt(#Str_Warning)+"...",Txt.S,#PB_MessageRequester_YesNo)
    
    ;/ if no is selected, exit procedure
    If Result = #PB_MessageRequester_No
      ProcedureReturn 0
    EndIf
  EndIf

  Debug "Roll Count on Site: "+Str(Count)
  Debug "Site ID Stored? "+Str(NavTree()\SiteID)
  
  ;/ build up a list of groups to delete, then call Database_Delete_Groups
  DatabaseQuery(#Databases_Master,"Select ID from AMS_Groups Where SiteID = '"+Str(SiteID)+"';")
  NewList Delete_Groups.i()
  ClearList(Delete_Groups())
  
  While NextDatabaseRow(#Databases_Master)
    AddElement(Delete_Groups())
    Delete_Groups() = GetDatabaseLong(#Databases_Master,0)
    Debug "Group added to delete pool: "+Str(Delete_Groups())
  Wend
  
  ForEach Delete_Groups()
    Database_Delete_Group(Delete_Groups(),1)  
  Next
  
  ;/ (3) Finally, delete the site
  Database_Update(#Databases_Master,"Delete from AMS_Sites Where ID = '"+Str(SiteID)+"';",#PB_Compiler_Line) ;/ delete Site
  Database_SetMainTimeStamp()
  Refresh_Site_List()
  
  ;/ if the site deleted was the default site, set the default site to the first site entry.
  If SiteID = System\Default_Site
    SelectElement(Sites(),0)
    System\Default_Site = Sites()\ID
    Database_SaveSettings()
  EndIf
  
  ;/ (4) Set trigger for NavTree Refresh
  SelectElement(Sites(),0)
  
  Debug "Set Site ID for navtree refresh: "+Str(Sites()\ID)
  System\Refresh_NavTree_Type = #NavTree_Site
  System\Refresh_NavTreeID = Sites()\ID
  
EndProcedure
Procedure.i Database_Create_Site()
  Protected SiteName.s, SiteCount.i, Duplicated.i, Position.i, SiteID.i

  ;/ (1) Count # of existing sites, if count >= Site_Limit (in 'Code' field), prompt that max has been reached and exit [DEMO]
  SiteCount = Database_CountQuery("Select Count(*) from AMS_Sites;)",#PB_Compiler_Line)
  Debug SiteCount
  If SiteCount >= System\Settings_SiteLimit
    MessageRequester("Error",tTxt(#Str_Sorry)+", "+tTxt(#Str_Demomodelimitationshavebeenreached)+"("+"=>"+Str(System\Settings_SiteLimit)+" "+tTxt(#Str_records)+")")
    ProcedureReturn 0
  EndIf
  
  ;/ (2) get name, if name is blank, exit.
  SiteName.s = InputRequesterEx(tTxt(#Str_Createsite)+"...", tTxt(#Str_Pleaseenternewsitename)+":","")
  If SiteName = "" : ProcedureReturn 0 : EndIf
  
  ;/ (3) Check Valididty of Site name (No blanks or duplicates)
  Duplicated = Database_CheckForDuplicate("Select Name from AMS_Sites;",SiteName)
  
  If Duplicated = 1
    MessageRequester(tTxt(#Str_Error)+" - "+tTxt(#Str_CannotcreateSite),tTxt(#Str_Sorry)+", "+tTxt(#Str_thissitenamealreadyexists),#PB_MessageRequester_Ok)
    ProcedureReturn 0
  EndIf

  ;/ (4) Create Site in database, create 'Unassigned' Group against the new sites ID (All sites must have unassigned bin)
  Database_Update(#Databases_Master, "INSERT INTO AMS_Sites (Name) VALUES ('"+SiteName+"')",#PB_Compiler_Line)
  ;Position = Database_IntQuery("Select Name from AMS_Sites where Name = '"+SiteName+"';")
  SiteID = Database_IntQuery("Select ID from AMS_Sites where Name = '"+SiteName+"';")
  Database_Update(#Databases_Master, "INSERT INTO AMS_Groups (GroupName, Type, SiteID) VALUES ('"+tTxt(#STR_Unassigned)+"', '0', '"+Str(SiteID)+"')",#PB_Compiler_Line)
  Database_SetSiteTimeStamp(SiteID)
  Debug "Site ID: "+Str(SiteID)
  System\Refresh_NavTree_Type = #NavTree_Site
  System\Refresh_NavTreeID = SiteID
;  Refresh_Group_List(1)
  
EndProcedure
Procedure.i Database_Create_Roll(GroupID.i) ;/ *!* High
  Protected Count.i, Result.S, Duplicate.i, Position.i, SiteId.i, SQL.s
  
  ;/ (1) Count # of existing Rolls, if count >= Record limit, prompt that max has been reached end exit procedure [Only for DEMO mode]
  Count = Database_CountQuery("Select Count(*) From AMS_Roll_Master;",#PB_Compiler_Line) ;/DNT
;  Count + Database_CountQuery("Select Count(*) From AMS_Roll_Data;")
  
  Debug "Records count: "+Str(Count) + " - Record Limit: "+Str(System\Settings_RollLimit)
  
  If System\Settings_RollLimit > 0 And Count => System\Settings_RollLimit
    MessageRequester(tTxt(#Str_Error), tTxt(#Str_Sorry)+", "+tTxt(#Str_Demomodelimitationshavebeenreached)+"("+"=>"+Str(System\Settings_RollLimit)+" "+tTxt(#Str_records)+")")
    ProcedureReturn 
  EndIf
  
  ;/ (2) Check validity of RollID, Is RollID blank or does RollID already exist? (can there be duplicates) - Question for PhilH.
  Result = InputRequesterEx(tTxt(#Str_Rollnameentry)+"...",tTxt(#Str_Pleaseinputnewrollname)+":","")
  
  ;/ (2) If no entry was made, exit creation process
  If Result = "" : ProcedureReturn 0 : EndIf

  ;/ (3) Check if Group name already exists on site, exit if true
  SiteID = Database_IntQuery("Select SiteID From AMS_Groups where ID = "+Str(GroupID)+";")
  Debug "****SITEID: "+Str(SiteID)+" *********"
  Sql.s = "Select AMS_Roll_Master.Name From AMS_Roll_Master, AMS_Groups where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(SiteID)
  Duplicate = Database_CheckForDuplicate(SQL,Result) ;/DNT
  If Duplicate = 1 : MessageRequester(tTxt(#Str_Error)+" - "+tTxt(#Str_Cannotcreateroll),tTxt(#Str_Sorry)+", "+tTxt(#Str_arollbythisnamealreadyexists),#PB_MessageRequester_Ok) : ProcedureReturn 0 : EndIf
    
  ;/ (4) Create new AMS_Roll_Master, allocate to GroupID and set Name as RollName
  Database_Update(#Databases_Master, "INSERT INTO AMS_Roll_Master (Name, GroupID, DateMade) VALUES ('"+Result+"','"+Str(GroupID)+"', "+Str(Date())+")",#PB_Compiler_Line) ;/DNT
  
  ;Sql.s = "Select AMS_Roll_Master.ID From AMS_Roll_Master, AMS_Groups where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Roll_Master.Name = '"+Result+"' and AMS_Groups.SiteID = "+Str(SiteID)
  Position = DatabaseLastInsertRowId(#Databases_Master)
  ;Position = Database_IntQuery(SQL) ;/DNT
  
  Database_SetRollTimeStamp(Position)
  ;Database_SetMainTimeStamp()
  
  System\Refresh_NavTree_Type = #NavTree_Roll
  System\Refresh_NavTreeID = Position
  System\Selected_Roll_ID_Text = Result
  System\Refresh_Roll_Information = 1
  
EndProcedure
Procedure.i Database_Update_RollMaster_FromForm(RollID.i)
  Protected Time.i, Txt.s
  
  Time = ElapsedMilliseconds()
  Debug "Updating - RollID: "+Str(RollID)+" (" + Str(System\Selected_Roll_ID) + ") - " + System\Selected_Roll_ID_Text ;/DNT
;   SQL = "Create TABLE [AMS_Roll_Master] ( [ID] INTEGER PRIMARY KEY,  [GroupID] CHAR,  [Name] CHAR,  [Type] CHAR,[Manufacturer] CHAR,  [Width] INT, "
;   SQL + "[Diameter] INT, [Suitability] CHAR,  [DateMade] INT,  [Screencount] INT, [Wall] INT, [Opening] INT, [Customer] CHAR," ;/ anilox types
;   SQL + "[Channel] FLOAT, [Angle] INT, [StylusAngle] FLOAT, " ;/ gravure types
;   SQL + "[Comments] CHAR,  [Operator] CHAR, [ReadingDate] Int, [Vol1] FLOAT,  [Vol2] CHAR,  [Vol3] CHAR,  [Vol4] CHAR,  [Vol5] CHAR,  " ;/ Master Reading
;   SQL + "[TopSnapImage] LONGBIN

  ;/ (1) Validate / Sanity check all fields (long job?) - If problem. prompt and exit - *!* no validation atm - required?
  
  ;Txt.s = "Update AMS_Roll_Master SET ManuFacturer = '"+Str(GetGadgetState(#Gad_Rollinfo_Manufacturer_String)) ;/DNT
  Txt.s = "Update AMS_Roll_Master SET ManuFacturer = '"+Str(Get_Manufacturer_Value(GetGadgetText(#Gad_Rollinfo_Manufacturer_String))) ;/DNT
  
  Txt.s + "', DateMade = "+Str(GetGadgetState(#Gad_Rollinfo_DateMade_Date)) ;/DNT
  ;Txt.s + ", Suitability = "+Str(GetGadgetState(#Gad_Rollinfo_Suitability_String)) ;/DNT
  Txt.s + ", Suitability = "+Str(Get_Suitability_Value(GetGadgetText(#Gad_Rollinfo_Suitability_String))) ;/DNT
  Txt.s + ", Screencount = '"+GetGadgetTextMac(#Gad_RollInfo_Screen_String) ;/DNT
  Txt.s + "', Wall = '"+GetGadgetTextMac(#Gad_RollInfo_Wall_String) ;/DNT
  Txt.s + "', Width = '"+GetGadgetTextMac(#Gad_RollInfo_Width_String) ;/DNT
  Txt.s + "', Opening = '"+GetGadgetTextMac(#Gad_RollInfo_Opening_String) ;/DNT
  Txt.s + "', Comments = '"+GetGadgetTextMac(#Gad_RollInfo_Comment_Box) ;/DNT
  Txt.s + "' where ID = '" + Str(RollID) + "';" ;/DNT
  
  Database_Update(#Databases_Master,Txt,#PB_Compiler_Line)
  Database_SetRollTimeStamp(RollID)
  
  Debug Str(ElapsedMilliseconds()-Time)+"ms"
EndProcedure

Procedure.i Database_Reassign_Roll(RollID.i,Group.l) ;/ *!*
  
  Database_Update(#Databases_Master,"Update AMS_Roll_Master SET GroupID = '"+Str(Group)+"' where ID = '" + Str(RollID) + "';",#PB_Compiler_Line)
  
  ;  Redraw_NavTree() :; SetGadgetState(#Gad_NavTree,Position-1)
  System\Showing_RollID = -1
  Redraw_RollID(Rollid)
  System\Refresh_NavTree_Type = #NavTree_Roll
  System\Refresh_NavTreeID = RollID
  
EndProcedure 
Procedure.i Database_Rename_Roll(RollID.i)
  Protected Result.S, Duplicate.i, RollName.S, RollType.i
  
  ;/ (-0) Check Group Type - 2 = Unassigned, which shouldn't be renamed.
  RollName.S = Database_StringQuery("Select NAME From AMS_Roll_Master Where ID = '"+Str(RollID)+"';")
;  GroupType = Val(Database_StringQuery("Select Type From AMS_Groups Where ID = '"+Str(GroupID)+"';"))
  Debug "Name: "+RollName
  
  ;/ (1) Request Group Name
  Result.S = InputRequesterEx(tTxt(#Str_Renameroll)+"...", tTxt(#Str_Pleaseenternewrollname)+":",RollName)
  
  ;/ (2) If no entry was made, exit creation process
  If Result = "" Or Result = RollName: ProcedureReturn 0 : EndIf
  
  ;/ (3) Check if Group name already exists on site, exit if true
  Duplicate = Database_CheckForDuplicate("Select Name From AMS_Roll_Master Where ID <> "+Str(RollID),Result)
  If Duplicate = 1 : MessageRequester(tTxt(#Str_Error)+" - "+tTxt(#Str_cannotrename),tTxt(#Str_Rollnamealreadyexistsforsite),#PB_MessageRequester_Ok) : ProcedureReturn 0 : EndIf
    
  ;/ (4) Create Group & set NavTree refresh flag
  Database_Update(#Databases_Master,"Update AMS_Roll_Master SET Name = '"+Result+"' where ID = '" + Str(RollID) + "';",#PB_Compiler_Line)

  System\Refresh_NavTree_Type = #NavTree_Roll
  System\Refresh_NavTreeID = RollID
EndProcedure

Procedure Database_ExportRoll(RollID.i)
  Protected Path.s, ReadingCount.i, Sql.s, Txt.s, Column.i, RowCount.i, ImageNumber.i, Length.i
  Protected NewList HistID.i()
  ClearList(HistID())
  ;/ Export Master Roll Data
  Debug "Exporting Roll"
  Path.s = GetSpecialFolder($23)+"Troika Systems\AMS\"
  CreateDirectory(Path+"Export")
  Path + "Export\"
  ImageNumber = 0
  If CreateFile(1,Path+"RollMaster.txt")
    ;/ Master data
    ;/ Name, Width, datemade, screencount, wall, opening, comments, operator, readingdate, vol1,vol2,vol3,vol4,vol5, volume, capacity
    ;/ Variance, lastreadingdate
    
    SQL.s = "Select Name, Width, datemade, screencount, wall, opening, comments, operator, readingdate, vol1, vol2, vol3, vol4, vol5, "
    SQL +   "volume, capacity, Variance, lastreadingdate, TopSnapImage from AMS_Roll_Master where ID = "+Str(RollID)+";"
    DatabaseQuery(#Databases_Master,SQL.s)
    Debug DatabaseError()
    
    WriteStringN(1, "Roll Master Data - ID: "+Str(RollID))
    While NextDatabaseRow(#Databases_Master)
      Txt.s = ""
      For Column = 0 To 17
        Txt.s + GetDatabaseString(#Databases_Master,Column)
        If Column < 17 : Txt.s + Chr(#VK_TAB) : EndIf
      Next
      WriteStringN(1,txt)
    Wend
    FinishDatabaseQuery(#Databases_Master)
    
    ;/ Master data Top snap blob
    DatabaseQuery(#Databases_Master,"Select TopSnapImage from AMS_Roll_Master Where ID = '"+Str(RollID)+"';")
    NextDatabaseRow(#Databases_Master)
    Debug "ColumnType: "+Str(DatabaseColumnType(#Databases_Master,0))
    Length = DatabaseColumnSize(#Databases_Master, 0) ; Display the content of the first field  
    ;Debug "Length: "+Str(Length)
    If Length > 0
      If System\ReferenceImage <> 0 : FreeMemory(System\ReferenceImage) : EndIf
      System\ReferenceImage = AllocateMemory(Length)
      System\Reference_Image_Length = Length
      GetDatabaseBlob(#Databases_Master,0,System\ReferenceImage,Length)
      CatchImage(#Image_2d_Image_Reference,System\ReferenceImage,Length)
      SaveImage(#Image_2d_Image_Reference,Path+"MasterTopSnap.bmp",#PB_ImagePlugin_BMP)
    EndIf 
    FinishDatabaseQuery(#Databases_Master)

    ;/ Export Roll Readings
    ;/ Number of records#

    RowCount = Database_CountQuery("Select Count(*) From AMS_Roll_Data where RollID = "+Str(RollID)+";",#PB_Compiler_Line)
    WriteStringN(1,Str(RowCount))
    ;/ (Inc filename of images)
    
    ;/ ReadingDate, Operator, Vol1, Vol2, Vol3, Vol4, Vol5, ImageName
    DatabaseQuery(#Databases_Master,"Select ID, Operator, ReadingDate, Vol1, Vol2, Vol3, Vol4, Vol5 from AMS_Roll_Data where RollID = "+Str(RollID)+";")
    Debug DatabaseError()
    WriteStringN(1, "Roll Reading Data - ID: "+Str(RollID))
    While NextDatabaseRow(#Databases_Master)
      AddElement(Histid())
      HistID() = GetDatabaseLong(#Databases_Master,0)
      Txt.s = Str(HistID())+ Chr(#VK_TAB)
      For Column = 1 To 7
        Txt.s + GetDatabaseString(#Databases_Master,Column)
        If Column < 7 : Txt.s + Chr(#VK_TAB) : EndIf
      Next
      WriteStringN(1,Txt)
    Wend
    FinishDatabaseQuery(#Databases_Master)  
    
    If ListSize(HistID()) > 0
      ForEach Histid()  
        DatabaseQuery(#Databases_Master,"Select HistTopSnapImage from AMS_Roll_Data Where ID = '"+Str(HistID())+"';")
        NextDatabaseRow(#Databases_Master)
        
        Length = DatabaseColumnSize(#Databases_Master, 0) ; Display the content of the first field  
        ;Debug "**** Blob Length: "+Str(Length)
        ;Debug System\Selected_HistoryID
        If Length > 0
          If System\CurrentImage <> 0 : FreeMemory(System\CurrentImage) : EndIf
          System\CurrentImage = AllocateMemory(Length)
          System\Current_Image_Length = Length
          GetDatabaseBlob(#Databases_Master , 0,System\CurrentImage,Length)
          CatchImage(#Image_2d_Image_Current, System\CurrentImage,Length)
          SaveImage(#Image_2d_Image_Current,Path+"HistTopSnap"+Str(HistID())+".bmp",#PB_ImagePlugin_BMP)
        EndIf 

        FinishDatabaseQuery(#Databases_Master) 
      Next
    EndIf
    
    
    ;/ Export general history
    ;/ RollID (Dynamic, when importing) Date, Type, Comments
    RowCount = Database_CountQuery("Select Count(*) From AMS_General_History where RollID = "+Str(RollID)+";",#PB_Compiler_Line)
    WriteStringN(1,Str(RowCount))
    
    DatabaseQuery(#Databases_Master,"Select Date, Type, Comments from AMS_General_History where RollID = "+Str(RollID)+";")
    WriteStringN(1, "Roll General History - ID: "+Str(RollID))
    
    While NextDatabaseRow(#Databases_Master)
      Txt.s = ""
      For Column = 0 To 2
        Txt.s + GetDatabaseString(#Databases_Master,Column)
        If Column < 2 : Txt.s + Chr(#VK_TAB) : EndIf
      Next
      WriteStringN(1,txt)
    Wend
    FinishDatabaseQuery(#Databases_Master)
    
    ;/ export 
    CloseFile(1)
    MessageRequester("Message","Exported successfully")
  Else
    MessageRequester("Error","Couln't create file")
  EndIf
  
EndProcedure
Procedure Database_ImportRoll(Site.i, Group.i)
  Protected Path.s, Count.i, Sql.s, Txt.s, Column.i, RowCount.i, ImageNumber.i, Length.i, RollName.s, Position.i, ImportImage.i, RollID.i
  
  If Site = 0 Or Group = 0 : Debug "Incorrect Site / Group Combination" : ProcedureReturn 0 : EndIf
  
  Path.s = GetSpecialFolder($23)+"Troika Systems\AMS\Export\"
  
  If ReadFile(10,Path+"RollMaster.txt")
    ReadString(10);/ Header
    Txt.s = ReadString(10)
    Debug Txt
    
    ;/ Roll Master write
    RollName.s = StringField(Txt,1,Chr(#VK_TAB))
    Debug "Import Rollname: "+RollName
    
    If Database_CheckForDuplicate("Select Name from AMS_Roll_Master;",RollName)
      MessageRequester("Error","This roll name ("+RollName+") already exists on Site")
      ProcedureReturn 0 
    EndIf
    
    ImportImage = Image_To_Memory(Path+"MasterTopSnap.bmp")
    If ImportImage > 0
      SetDatabaseBlob(#Databases_Master, 0, *ImMem, MemorySize(*ImMem))
    EndIf
    
    SQL.s = "Insert into AMS_Roll_Master (GroupID, Name, Width, datemade, screencount, wall, opening, comments, operator, readingdate, vol1,vol2,vol3,vol4,vol5, volume, capacity, "
    SQL.s + "Variance, lastreadingdate, TopSnapImage) Values ("+Str(Group)+", "
    
    For Column = 1 To 18
      SQL + "'"+StringField(Txt,Column,Chr(#VK_TAB))+"', "
    Next
    SQL + "?)" ;/ blob 
    
    Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)
    
    
    ;/ Roll Data Write
    RollID = Database_IntQuery("Select ID from AMS_Roll_Master where Name = '"+RollName +"' and GroupID = "+Str(Group))
    Debug RollID
    
    If RollID > 0
    
    RowCount = Val(ReadString(10))
    ReadString(10) ;/ header line
    For Count = 1 To RowCount
      txt.s = ReadString(10)
      
      ImageNumber = Val(StringField(Txt,1,Chr(#VK_TAB)))
      If Imagenumber > 0
        ImportImage = Image_To_Memory(Path+"HistTopSnap"+Str(ImageNumber)+".bmp")
        If ImportImage > 0
          SetDatabaseBlob(#Databases_Master, 0, *ImMem, MemorySize(*ImMem))
        EndIf
      EndIf
      
      If ImageNumber > 0
        SQL.s = "Insert Into AMS_Roll_Data (RollID, Operator, ReadingDate,  Vol1, Vol2, Vol3, Vol4, Vol5, HistTopSnapImage) Values ("+Str(RollId)+", "
      Else
        SQL.s = "Insert Into AMS_Roll_Data (RollID, Operator, ReadingDate,  Vol1, Vol2, Vol3, Vol4, Vol5) Values ("+Str(RollId)+", "
      EndIf
      
      If ImageNumber > 0
        For Column = 2 To 8
          SQL + "'"+StringField(Txt,Column,Chr(#VK_TAB))+"', "
        Next
        SQL + "?)" ;/ blob 
      Else
        For Column = 2 To 8
          SQL + "'"+StringField(Txt,Column,Chr(#VK_TAB))+"'"
          If column < 8 : SQL+", " : EndIf
        Next
        SQL + ")"
      EndIf
      
      Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)
    Next
    
    ;/ Roll Damage history Write
    RowCount = Val(ReadString(10))
    ReadString(10) ;/ header line
    For Count = 1 To RowCount
      txt.s = ReadString(10)
      SQL.s = "Insert Into AMS_General_History (Date, Type, Comments, RollID) Values ("
      
      For Column = 1 To 3
        SQL + "'"+StringField(Txt,Column,Chr(#VK_TAB))+"', "
      Next
      
      SQL + Str(RollID)+")"
      Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)  
    Next
  Else
    MessageRequester("Error","Retrieved Roll ID of zero, stopping import now")
  EndIf
  
    CloseFile(10)
    
  Else
    MessageRequester("Error","Unable to import, No Files to import?")
    ProcedureReturn 
  EndIf
  
  Position.i = GetGadgetState(#Gad_Navtree)
  If Position < 0 : Position = 0 : EndIf 
  
  System\Refresh_NavTree_Type = #NavTree_Roll
  System\Refresh_NavTreeID = Position
  System\Selected_Roll_ID_Text = RollName
  System\Refresh_Roll_Information = 1
  
EndProcedure

Procedure Show_Window(Panel.i, LineNumber.i)
  Protected MyLoop.i

  Flush_Events()
  
  Debug "Called Show Window from Line: "+Str(LineNumber)
  
  If System\Showing_Panel = #Panel_Roll_Info And Panel <> #Panel_Roll_Info
    RollInfo_CheckEditted()
  EndIf
  
  If System\Editted = 1
    If MessageRequester(tTxt(#Str_Message)+"...",tTxt(#Str_Youhavemadechangestotherollinformationdata)+", "+tTxt(#Str_doyouwanttosave)+"?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      Database_Update_RollMaster_FromForm(System\Selected_Roll_ID)
    Else
      System\Editted = 0
    EndIf
  EndIf
  
  If Panel = System\Showing_Panel : ProcedureReturn : EndIf ;/ no need to redraw if already on

  SendMessage_(WindowID(#Window_Main),#WM_SETREDRAW,#False,0)
  
  ;/ disable all export icons, re-enabled by window selected (below)

  DisableGadget(#Gad_Icon_Export_PDF,1)
  DisableGadget(#Gad_Icon_Export_XLS,1)
  DisableGadget(#Gad_Icon_Export_CSV,1)
  DisableMenuItem(99,#Menu_File_Export_PDF,1)
  DisableMenuItem(99,#Menu_File_Export_XLS,1)
  DisableMenuItem(99,#Menu_File_Export_CSV,1)

  For MyLoop = #Gad_Hide_All_Begin To #Gad_Hide_All_End
    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf 
  Next
  
  Select Panel.i
    Case #Panel_2D_View
      For MyLoop = #Gad_2D_Analysis_Hide_Begin To #Gad_2D_Analysis_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next
      SetWindowColor(#Window_Main,#WinCol_2d3dDebug)
      System\Showing_Panel = #Panel_2D_View
      
    Case #Panel_3d_View
      For MyLoop = #Gad_3D_Analysis_Hide_Begin To #Gad_3D_Analysis_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next
      SetWindowColor(#Window_Main,#WinCol_2d3dDebug)
      System\Showing_Panel = #Panel_3d_View
      
    Case #Panel_Debug
      For MyLoop = #Gad_MessageList_Hide_Begin To #Gad_MessageList_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next
      SetWindowColor(#Window_Main,#WinCol_2d3dDebug)
      System\Showing_Panel = #Panel_Debug
      
    Case #Panel_HomeScreen
      For MyLoop = #Gad_Welcome_Hide_Begin To #Gad_Welcome_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next

      SetWindowColor(#Window_Main,#WinCol_HomeScreen)
      System\Showing_Panel = #Panel_HomeScreen
      
    Case #Panel_Roll_List
      For MyLoop = #Gad_RollList_Hide_Begin To #Gad_RollList_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next  
      SetWindowColor(#Window_Main,#WinCol_RollInfo)
      System\Showing_Panel = #Panel_Roll_List
      DisableGadget(#Gad_Icon_Export_PDF,0)
      DisableGadget(#Gad_Icon_Export_XLS,0)
      DisableGadget(#Gad_Icon_Export_CSV,0)
      DisableMenuItem(99,#Menu_File_Export_PDF,0)
      DisableMenuItem(99,#Menu_File_Export_XLS,0)
      DisableMenuItem(99,#Menu_File_Export_CSV,0)
      
      
    Case #Panel_Group_List
      For MyLoop = #Gad_Report_Hide_Begin To #Gad_Report_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next  
      SetWindowColor(#Window_Main,#WinCol_Report)
      System\Showing_Panel = #Panel_Group_List
      DisableGadget(#Gad_Icon_Export_PDF,0)
      DisableGadget(#Gad_Icon_Export_XLS,0)
      DisableGadget(#Gad_Icon_Export_CSV,0)
      DisableMenuItem(99,#Menu_File_Export_PDF,0)
      DisableMenuItem(99,#Menu_File_Export_XLS,0)
      DisableMenuItem(99,#Menu_File_Export_CSV,0)      
      
    Case #Panel_Roll_Info
      For MyLoop = #Gad_RollInfo_Hide_Begin To #Gad_RollInfo_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next
      HideGadget(#Gad_RollInfo_Commit,1)  
      HideGadget(#Gad_RollInfo_Undo,1) 
      SetWindowColor(#Window_Main,#WinCol_RollInfo)
      System\Showing_Panel = #Panel_Roll_Info
      Debug "Showing Roll Window"
      DisableGadget(#Gad_Icon_Export_PDF,0)
      DisableGadget(#Gad_Icon_Export_XLS,0)
      DisableGadget(#Gad_Icon_Export_CSV,0)
      DisableMenuItem(99,#Menu_File_Export_PDF,0)
      DisableMenuItem(99,#Menu_File_Export_XLS,0)
      DisableMenuItem(99,#Menu_File_Export_CSV,0)
      
    Case #Panel_SQL
      For MyLoop = #Gad_SQL_Hide_Begin To #Gad_SQL_Hide_End
        If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf 
      Next
      SetWindowColor(#Window_Main,#WinCol_HomeScreen)
      System\Showing_Panel = #Panel_SQL
      

  EndSelect
  Flush_Events()
  SendMessage_(WindowID(#Window_Main),#WM_SETREDRAW,#True,0)
  Flush_Events()
  RedrawWindow_(WindowID(#Window_Main),#Null,#Null,#RDW_INVALIDATE|#RDW_UPDATENOW|#RDW_ERASE)
  Flush_Events()
EndProcedure

Procedure Image_Manual_Load(Master.i=0,HistoryID.i=0)
  Protected File.s, Pattern$, Pattern.i, ImportImage.i, Delete.i
  Pattern$ = tTxt(#Str_Imagefile)
  Pattern$ + "|*.jpg;*.bmp;*.png;*.jpeg" ;/DNT
  Pattern = 0    ; use the first of the three possible patterns as standard
  Delete.i = 0
  File = OpenFileRequester(tTxt(#Str_Pleasechoosefiletoload), System\Last_Image_Import_Directory, Pattern$, Pattern)
  System\Last_Image_Import_Directory.s = GetPathPart(File)
  If File
    ;/ Read in image file
    If LCase(GetExtensionPart(File)) <> "jpg" ;/ only store compressed images
      ImportImage = LoadImage(#PB_Any,File)
      If ImportImage <> 0
        File = GetTemporaryDirectory()+"\"+GetFilePart(File)+".jpg"
        SaveImage(ImportImage,File,#PB_ImagePlugin_JPEG,2)
        FreeImage(ImportImage)
        ImportImage = Image_To_Memory(File)
        DeleteFile(File)
      EndIf
    Else
      ImportImage = Image_To_Memory(File)
    EndIf
    
    If ImportImage > 0
      SetDatabaseBlob(#Databases_Master, 0, *ImMem, MemorySize(*ImMem))

      If Master = 1 ;/ writing image to master table
        Database_Update(#Databases_Master,"Update AMS_Roll_Master SET TopSnapImage = ? Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line) ;/DNT
      Else
        ;/ Write image to HistoryID
        Database_Update(#Databases_Master,"Update AMS_Roll_Data SET HistTopSnapImage = ? Where ID = "+Str(HistoryID)+";",#PB_Compiler_Line) ;/DNT
      EndIf
      System\Refresh_Roll_Information = 1 : System\Showing_Panel = 0 ;/
      Database_SetRollTimeStamp(System\Selected_Roll_ID)
    Else
      ;MessageRequester(tTxt(#Str_Error),tTxt(#Str_d
      ProcedureReturn 0
    EndIf
  EndIf
EndProcedure
Procedure Image_Manual_Save(Image.i)
  Protected File.s, Pattern$, Pattern.i, ImportImage.i, SavingImage.i, SaveFormat.i
  
    If Image = 1
      SavingImage = #Image_2d_Image_Reference
    ElseIf Image = 2
      SavingImage = #Image_2d_Image_Current
    EndIf
  
  
  Pattern$ = "*.jpg|*.bmp|*.png"  ;/DNT
  Pattern$ = "Jpg|*.jpg;*.jpeg|BMP|*.BMP|PNG|*.PNG"  ;/DNT

  Pattern = 0    ; use the first of the three possible patterns as standard
  File = SaveFileRequester(tTxt(#Str_Pleasechoosefilenametosaveas), System\ImportPath, Pattern$, Pattern)
  If File
    
    SaveFormat = SelectedFilePattern()
    Debug SaveFormat
    If SaveFormat = 0 ;/ jpg
      If GetExtensionPart(File) <> ".jpg" : File + ".Jpg" : EndIf ;/DNT
    EndIf
    If SaveFormat = 1 ;/ bmp
      If GetExtensionPart(File) <> ".bmp" : File + ".bmp" : EndIf ;/DNT
    EndIf
    If SaveFormat = 2 ;/ png
      If GetExtensionPart(File) <> ".png" : File + ".Png" : EndIf ;/DNT
    EndIf
    
    If SaveFormat = 0
      SaveImage(SavingImage,File,#PB_ImagePlugin_JPEG)
    EndIf
    
    If SaveFormat = 1
      SaveImage(SavingImage,File,#PB_ImagePlugin_BMP)
    EndIf
    
    If SaveFormat = 2
      SaveImage(SavingImage,File,#PB_ImagePlugin_PNG)
    EndIf

  Else
    ProcedureReturn 0
  EndIf
EndProcedure
Procedure.i Import_LoadAMS()
  Protected Txt.s
  
  If OpenFile(1,System\ImportPath+"Anilox Manager Import.ams") ;/ read the AMS header (single string) and close the file  ;/DNT
    Txt.S = ReadString(1)
    CloseFile(1)
  Else
    ProcedureReturn 0
  EndIf
  
  With AMS_Import ;/ split the string into its component parts (tab delimited)
    \Header.S = StringField(Txt,1,Chr(9)) ;/1
    
    ;/  Added AMS2 export updates - new fields at end are 
    ;/ Date Format - 1 For MMDDYY, 0 = DDMMYY - 25
    ;/ Volume Units - 1 For CCM3, 0 For BCM - 26
    ;/ Measure Units - 1 For um, 0 For thou - 27
    ;/ LPI Units - 1 For LPCM, 0 For LPI - 28
    ;/ PixelsPerMM - floating point. - 29
    Debug "*** AMS Load: Header = "+\Header
    
    If \Header = "AMS2"
      \DateFormat = Val(StringField(Txt,25,Chr(9))) ;/ 25
      \VolumeUnit = Val(StringField(Txt,26,Chr(9))) ;/ 26
      \MeasurementUnit = Val(StringField(Txt,27,Chr(9))) ;/ 27
      \ScreenUnit = Val(StringField(Txt,28,Chr(9))) ;/ 27
      \PPM = ValF(ReplaceString(StringField(Txt,29,Chr(9)),",",".")) ;/ 29
    Else
      \DateFormat = 0
      If System\Settings_Date_Format = #Settings_DateUnit_MMDDYYYY
        \DateFormat = 1
      EndIf
    EndIf
    
    \CustomerID.S = StringField(Txt,2,Chr(9)) ;/2
    \RollID.S = StringField(Txt,3,Chr(9)) ;/3
    \Operator.S = StringField(Txt,4,Chr(9)) ;/4
    \DateStamp.S = StringField(Txt,5,Chr(9)) ;/5
    
    If \DateFormat = 0 ;/ DDMMYY
      \Day = Val(StringField(Left(AMS_Import\DateStamp,10),1,"/"))
      \Month = Val(StringField(Left(AMS_Import\DateStamp,10),2,"/"))
      \Year = Val(StringField(Left(AMS_Import\DateStamp,10),3,"/"))
    Else
      \Day = Val(StringField(Left(AMS_Import\DateStamp,10),2,"/"))
      \Month = Val(StringField(Left(AMS_Import\DateStamp,10),1,"/"))
      \Year = Val(StringField(Left(AMS_Import\DateStamp,10),3,"/"))
    EndIf

    \DateNum = Date(\Year,\Month,\Day,0,0,0)

    If \DateNum = < 0 : \DateNum = Date() : EndIf ;/ a 'Gotcha' for bad translations (discovered whilst using US date format
    ;\time.S = StringField(Txt,6,Chr(9)) ;/ 6 -?? Sometimes '1'
    \SamplesUsed.S = StringField(Txt,6,Chr(9)) ;/ 7 -always 8??
    \MaxSamples.S = StringField(Txt,7,Chr(9)) ;/ 8 -?? Sometimes the volume (Avg mode??)
    \Sample1.S = ReplaceString(StringField(Txt,8,Chr(9)),",",".") ;/9
    \Sample2.S = ReplaceString(StringField(Txt,9,Chr(9)),",",".") ;/10
    \Sample3.S = ReplaceString(StringField(Txt,10,Chr(9)),",",".") ;/11
    \Sample4.S = ReplaceString(StringField(Txt,11,Chr(9)),",",".") ;/12
    \Sample5.S = ReplaceString(StringField(Txt,12,Chr(9)),",",".") ;/13
    \Sample6.S = ReplaceString(StringField(Txt,13,Chr(9)),",",".") ;/14
    \Sample7.S = ReplaceString(StringField(Txt,14,Chr(9)),",",".") ;/15
    \Sample8.S = ReplaceString(StringField(Txt,15,Chr(9)),",",".") ;/ 16 - ?? Sometimes the volume (Avg mode?)
    ;/ 16?? ;/ Volume averaged
    \Volume.S = ReplaceString(StringField(Txt,17,Chr(9)),",",".") ;/ 17 Volume displayed
    ;/ Volume displayed
    \Depth.S = ReplaceString(StringField(Txt,18,Chr(9)),",",".") ;/ 18
    \CellOpening.S = ReplaceString(StringField(Txt,19,Chr(9)),",",".") ;/ 19
    \CellWall.S = ReplaceString(StringField(Txt,20,Chr(9)),",",".") ;/ 20
    \RollScreenCount.S = ReplaceString(StringField(Txt,21,Chr(9)),",",".") ;/ 21
    \RollAngle.S = ReplaceString(StringField(Txt,22,Chr(9)),",",".") ;/ 22
    \AniCAM_Config.S = ReplaceString(StringField(Txt,23,Chr(9)),",",".") ;/ 23
    \SavedImagePath.S = ReplaceString(StringField(Txt,24,Chr(9)),",",".") ;/ 24
    Debug "*** AMS Load: Image Path: "+\SavedImagePath
  EndWith 
  
;  CallDebugger
  
  If AMS_Import\SamplesUsed = "0" ;/ exported single view
    AMS_Import\SamplesUsed = "1"
    AMS_Import\Sample1 = AMS_Import\Volume
  EndIf
  
  Debug "DateStamp: "+AMS_Import\DateStamp
  Debug "Day: "+StringField(Left(AMS_Import\DateStamp,10),1,"/")
  Debug "Month: "+StringField(Left(AMS_Import\DateStamp,10),2,"/")
  Debug "Year: "+StringField(Left(AMS_Import\DateStamp,10),3,"/")
  
  Debug "**AMS Image File**: "+AMS_Import\SavedImagePath
  ;  Debug "Date as Val: "+Str(Date(
  Debug "RollID: "+System\Selected_Roll_ID_Text +" - AMS RollID"+ AMS_Import\RollID
  ProcedureReturn 1
EndProcedure

Procedure.i Import_AMS(NoLoad.i = 0) ;/ NoLoad for Master Import, to prevent reloading of asset

  Protected Txt.S, MyLoop.i, Result.i, Date.i, Count.i, ImportImage.i, AMS_Loaded.i
  ;/ Processes the import of AMS files into the SQL database.
  ;/ Improves on current AMS solution, as allows flexibility on Roll ID matching (warns and allows override).
  
  ;/ (1) Count # of existing Rolls, if count >= Record limit, prompt that max has been reached end exit procedure [Only for DEMO mode]
  ;Count = Database_CountQuery("Select Count(*) From AMS_Roll_Master;")
  Count = Database_CountQuery("Select Count(*) From AMS_Roll_Data where RollID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
  Debug "Records count: "+Str(Count) + " - Record Limit: "+Str(System\Settings_ReadingsLimit)
  
  If System\Settings_ReadingsLimit > 0 And Count => System\Settings_ReadingsLimit
    MessageRequester(tTxt(#Str_Error), tTxt(#Str_Sorry)+", "+tTxt(#Str_Demomodelimitationshavebeenreached)+"("+Str(System\Settings_ReadingsLimit)+" "+"historical "+tTxt(#Str_records)+")")
    ProcedureReturn 
  EndIf

  If FileSize(System\ImportPath+"Anilox Manager Import.ams") <= 0 ;/ exit if file doesn't exist  ;/DNT
    MessageRequester(tTxt(#Str_Warning),tTxt(#Str_NoAMSfileswerefound),#PB_MessageRequester_Ok)
    ProcedureReturn 0
  EndIf
  
  If NoLoad = 0 
    If Import_LoadAMS()
      
    Else
      ;/ failed to open, warn and exit
      MessageRequester(tTxt(#Str_Error),tTxt(#Str_UnabletoopentheAMSheaderfile),#PB_MessageRequester_Ok|#MB_ICONWARNING)
      ProcedureReturn 1
    EndIf 
  EndIf
  

  If AMS_Import\RollID <> System\Selected_Roll_ID_Text ;/ If there's a RollID mis-match, warn user and ask if import should continue.
    Txt.S = tTxt(#Str_TherollIDontheAMSimportfiledoesntmatchthecurrentlyselectedrollID)+":"+Chr(10)
    Txt.S + Chr(10)
    Txt.S + tTxt(#Str_CurrentlyselectedrollID)+":"+" "+System\Selected_Roll_ID_Text +Chr(10)
    Txt.S + tTxt(#Str_RollIDonAMSimportfile)+":"+" "+AMS_Import\RollID +Chr(10)
    Txt.S + Chr(10)
    Txt.S + tTxt(#Str_ContinueimportonmismatchedrollID)+"?"
    Result = MessageRequester(tTxt(#Str_Warning)+"...",Txt,#PB_MessageRequester_YesNo)
    
    ;/ if no is selected, exit procedure
    If Result = #PB_MessageRequester_No
      ProcedureReturn 0
    EndIf
  EndIf
  
  ;/ Check for duplicate values
  
  ;/ Identify Where the import should go
  Date.i = Database_IntQuery("Select ReadingDate From AMS_Roll_Master where ID = "+Str(System\Selected_Roll_ID)+";")
  Count.i = Database_CountQuery("Select Count(*) From AMS_Roll_Data where RollID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
  
  Debug "Importing on RollID: "+Str(System\Selected_Roll_ID)
  Debug "Date on Roll Master = "+Str(Date)
  Debug "Count of Roll Data = "+Str(Count)
  
  ;/ Read in image file
  ImportImage = Image_To_Memory(AMS_Import\SavedImagePath)
  If ImportImage > 0 : SetDatabaseBlob(#Databases_Master, 0, *ImMem, MemorySize(*ImMem)) : EndIf
  
  If Date = 0 ;/ Assume no Original import, so Import to Roll Master
    Txt.S = "Update AMS_Roll_Master SET "
    Debug "Samples used: "+AMS_Import\SamplesUsed
    Select AMS_Import\SamplesUsed
      Case "1"
        Txt.S + "ReadingDate = "+Str(AMS_Import\DateNum)+", Operator = '"+AMS_Import\Operator+"', Vol3 = "+AMS_Import\Sample1 ;/DNT
      Case "2"
        Txt.S + "ReadingDate = "+Str(AMS_Import\DateNum)+", Operator = '"+AMS_Import\Operator+"', Vol2 = "+AMS_Import\Sample1+", Vol4 = "+AMS_Import\Sample2 ;/DNT
      Case "3"
        Txt.S + "ReadingDate = "+Str(AMS_Import\DateNum)+", Operator = '"+AMS_Import\Operator+"', Vol1 = "+AMS_Import\Sample1+", Vol3 = "+AMS_Import\Sample2+", Vol5 = "+AMS_Import\Sample3 ;/DNT
      Case "4"
        Txt.S + "ReadingDate = "+Str(AMS_Import\DateNum)+", Operator = '"+AMS_Import\Operator+"', Vol1 = "+AMS_Import\Sample1+", Vol2 = "+AMS_Import\Sample2+", Vol4 = "+AMS_Import\Sample3+", Vol5 = "+AMS_Import\Sample4 ;/DNT
      Case "5"
        Txt.S + "ReadingDate = "+Str(AMS_Import\DateNum)+", Operator = '"+AMS_Import\Operator+"', Vol1 = "+AMS_Import\Sample1+", Vol2 = "+AMS_Import\Sample2+", Vol3 = "+AMS_Import\Sample3+", Vol4 = "+AMS_Import\Sample4+", Vol5 = "+AMS_Import\Sample5 ;/DNT
    EndSelect
    If ImportImage > 0
      Txt.S + ", TopSnapImage = ?" ;/DNT
    EndIf
   
    ;Txt.S + " Where ID = "+Str(System\Selected_Roll_ID)+";"
    Txt.S + ", AniCAM_Config = '"+AMS_Import\AniCAM_Config+"', Depth = "+AMS_Import\Depth + " Where ID = "+Str(System\Selected_Roll_ID)+";"
    
    Database_Update(#Databases_Master,Txt.S,#PB_Compiler_Line)

  Else  ;/ Assume original import already on, so import to history list
    
    Txt.S = "INSERT INTO AMS_Roll_Data (RollID, "
    Select AMS_Import\SamplesUsed
      Case "1"
        Txt.S + "ReadingDate, Operator, Vol3, AniCAM_Config, Depth, HistTopSnapImage) VALUES ("
        Txt.S + Str(System\Selected_Roll_ID)+","+Str(AMS_Import\DateNum)+",'"+AMS_Import\Operator+"',"+AMS_Import\Sample1
        
      Case "2"
        Txt.S + "ReadingDate, Operator, Vol2, Vol4, AniCAM_Config, Depth, HistTopSnapImage) VALUES ("
        Txt.S + Str(System\Selected_Roll_ID)+","+Str(AMS_Import\DateNum)+",'"+AMS_Import\Operator+"',"+AMS_Import\Sample1+","+AMS_Import\Sample2
        
      Case "3"
        Txt.S + "ReadingDate, Operator, Vol1, Vol3, Vol5, AniCAM_Config, Depth, HistTopSnapImage) VALUES ("
        Txt.S + Str(System\Selected_Roll_ID)+","+Str(AMS_Import\DateNum)+",'"+AMS_Import\Operator+"',"+AMS_Import\Sample1+","+AMS_Import\Sample2+","+AMS_Import\Sample3
        
      Case "4"
        Txt.S + "ReadingDate, Operator, Vol1, Vol2, Vol4, Vol5, AniCAM_Config, Depth, HistTopSnapImage) VALUES ("
        Txt.S + Str(System\Selected_Roll_ID)+","+Str(AMS_Import\DateNum)+",'"+AMS_Import\Operator+"',"+AMS_Import\Sample1+","+AMS_Import\Sample2+","+AMS_Import\Sample3+","+AMS_Import\Sample4
        
      Case "5"
        Txt.S + "ReadingDate, Operator, Vol1, Vol2, Vol3, Vol4, Vol5, AniCAM_Config, Depth, HistTopSnapImage) VALUES ("
        Txt.S + Str(System\Selected_Roll_ID)+","+Str(AMS_Import\DateNum)+",'"+AMS_Import\Operator+"',"+AMS_Import\Sample1+","+AMS_Import\Sample2+","+AMS_Import\Sample3+","+AMS_Import\Sample4+","+AMS_Import\Sample5
    EndSelect
    
    Txt.s + ", '"+AMS_Import\AniCAM_Config+"', "+AMS_Import\Depth+", ?"+")"+";"
    Database_Update(#Databases_Master,Txt.S,#PB_Compiler_Line)

  EndIf
  
  ;/ check if current master data is blank, and populate if true.
  
  If Database_IntQuery("Select ScreenCount from AMS_Roll_Master Where ID = "+Str(System\Selected_Roll_ID)) = 0
    If Val(AMS_Import\RollScreenCount) > 0
      Database_Update(#Databases_Master,"Update AMS_Roll_Master Set ScreenCount = "+AMS_Import\RollScreenCount+" Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
    EndIf
  EndIf
  
  If Database_IntQuery("Select Wall from AMS_Roll_Master Where ID = "+Str(System\Selected_Roll_ID)) = 0
    If Val(AMS_Import\CellWall) > 0
      Database_Update(#Databases_Master,"Update AMS_Roll_Master Set Wall = "+AMS_Import\CellWall+" Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
    EndIf
  EndIf
  
  If Database_IntQuery("Select Opening from AMS_Roll_Master Where ID = "+Str(System\Selected_Roll_ID)) = 0
    If Val(AMS_Import\CellOpening) > 0
      Database_Update(#Databases_Master,"Update AMS_Roll_Master Set Opening = "+AMS_Import\CellOpening+" Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
    EndIf
  EndIf  
  
  ;/ Set last reading date to today
  Database_Update(#Databases_Master,"UPDATE AMS_Roll_Master SET LastReadingDate = "+Str(Date())+" Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line) ;/DNT
  
  Database_SetRollTimeStamp(System\Selected_Roll_ID)
  
  System\Refresh_Roll_Information = 1 : System\Showing_Panel = 0 ;/
  
  If System\DeleteAfterImport = 1
    DeleteFile(System\ImportPath+"Anilox Manager Import.ams") ;/DNT
    DeleteFile(System\ImportPath+"Image1.jpg") ;/DNT
  EndIf
  
  ProcedureReturn 1
  
EndProcedure
Procedure.i Import_AMS_Master() ;/*New*
  Protected Txt.S, MyLoop.i, Result.i, Date.i, Count.i, ImportImage.i, DB_RollID.i, DB_UnassignedGroup.i, RollExisted.i
  ;/ Processes the import of AMS files into the SQL database.
  ;/ Will identify if the RollID exists, if so, it will add automatically to that roll, otherwise, it will generate new RollID based on AMS file details

  ;/ Roll ID MUST have a name for this to work, if RollID is blank, will exit
  
  ;/ (1) Count # of existing Rolls, if count >= Record limit, prompt that max has been reached end exit procedure [Only for DEMO mode]

  If FileSize(System\ImportPath+"\Anilox Manager Import.ams") <= 0 ;/ exit if file doesn't exist  ;/DNT
    ;MessageRequester("Warning","No AMS files were found",#PB_MessageRequester_Ok)
    ProcedureReturn 0
  EndIf
  
  If Import_LoadAMS()

  Else
    ;/ failed to open, warn and exit
    If System\WindowMinimized = 1
      WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMS)+" "+"- "+tTxt(#Str_Message),tTxt(#Str_CannotopentheAMSfileforimport),3000)
    Else
      MessageRequester(tTxt(#Str_Error),tTxt(#Str_UnabletoopentheAMSheaderfile),#PB_MessageRequester_Ok|#MB_ICONWARNING)
    EndIf
    ProcedureReturn 0
  EndIf 

  Debug "**AMS Image File**: "+AMS_Import\SavedImagePath
  
  ;/ Is RollID populated?  If Not, Exit
  If AMS_Import\RollID = ""
    If System\WindowMinimized = 1
      WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),tTxt(#Str_CannotimportduetorollIDonAMSfilebeingblank),3000)
    Else
      MessageRequester(tTxt(#Str_Error),tTxt(#Str_CannotcompletemasterimportifRollIDfieldisblank),#PB_MessageRequester_Ok|#MB_ICONWARNING)
    EndIf
    ProcedureReturn 0
  EndIf
      
  ;/ Check RollID for existance in Database
  If Multi_Site_Mode = 0
    DB_RollID = Database_IntQuery("Select ID From AMS_Roll_Master Where Name = '"+AMS_Import\RollID+"';")
    Debug "Import: RollID check - Single Site - RollID: "+Str(DB_RollID)
  Else
    Debug System\Default_Site
    DB_RollID = Database_IntQuery("Select AMS_Roll_Master.ID From AMS_Roll_Master, AMS_Groups Where AMS_Roll_Master.Name = '"+AMS_Import\RollID+"' and AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = "+Str(System\Default_Site)+";")
    Debug "Import: RollID check - Multi Site - RollID: "+Str(DB_RollID)
  EndIf
  
  RollExisted = DB_RollID ;/ for balloon message
  Count = Database_CountQuery("Select Count(*) From AMS_Roll_Master;",#PB_Compiler_Line)
  
  ;/ Check the Roll count if we're generating a new roll (for limits etc,.)
  If System\Settings_RollLimit > 0 And DB_RollID = 0 And Count => System\Settings_RollLimit 
    If System\WindowMinimized = 1
      WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),tTxt(#Str_Cannotimportduetorollcountlimitbeingreached),3000)
    Else
      MessageRequester(tTxt(#Str_Error), tTxt(#Str_Sorry)+", "+tTxt(#Str_Cannotimportduetorollcountlimitbeingreached)+"("+Str(System\Settings_RollLimit)+")")
    EndIf    
    ProcedureReturn 0
  EndIf

  If DB_RollID > 0 ;/ Roll exists - check readings on roll (for limits etc)
    Count = Database_CountQuery("Select Count(*) From AMS_Roll_Data where RollID = "+Str(DB_RollID)+";",#PB_Compiler_Line)
    
    Debug "Records count: "+Str(Count) + " - Record Limit: "+Str(DB_RollID)
    
    If System\Settings_ReadingsLimit > 0 And Count => System\Settings_ReadingsLimit
      If System\WindowMinimized = 1
        WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),tTxt(#Str_Cannotimportduetoreadingcountrestrictions),3000)
      Else
        Txt.s = tTxt(#Str_Sorry)+", "+tTxt(#Str_Demomodelimitationshavebeenreached)
        Txt + "("+Str(System\Settings_ReadingsLimit)+" "+tTxt(#Str_Historicalreadings)+")"
        Txt + Chr(10) + Chr(10)
        Txt + tTxt(#Str_RollIDonAMSimportfile)+": "+ AMS_Import\RollID
        MessageRequester(tTxt(#Str_Error), Txt)
      EndIf
      
      ProcedureReturn 0
    EndIf
  EndIf
  
  Debug "Roll ID Exists? (-0 = No): "+Str(DB_RollID)
  
  If DB_RollID = 0 ;/ Doesn't Exist, so create in Database
    If Multi_Site_Mode = 0
      DB_UnassignedGroup = Database_IntQuery("Select ID From AMS_Groups Where Type = 0;")
    Else
      DB_UnassignedGroup = Database_IntQuery("Select ID From AMS_Groups Where Type = 0 and SiteID = "+Str(System\Default_Site)+";")
    EndIf

    Debug "Unassigned Group: "+Str(DB_UnassignedGroup)
    
    Txt.S = "INSERT INTO AMS_Roll_Master (GroupID,Name,Suitability,ScreenCount,Wall,Opening,DateMade, LastReadingDate,Operator)"
    Txt.S + " VALUES ('"+Str(DB_UnassignedGroup)+"','"+AMS_Import\RollID+"', 1, '"+AMS_Import\RollScreenCount+"', "+AMS_Import\CellWall+", "+AMS_Import\CellOpening+","+Str(Date()) +", "+Str(Date())+" ,'"+AMS_Import\Operator+"');"  ;/DNT
    Database_Update(#Databases_Master, Txt,#PB_Compiler_Line)  
    
    ;/ Added RollID should now be available, get RollID database ID
    DB_RollID = Database_IntQuery("Select ID From AMS_Roll_Master Where Name = '"+AMS_Import\RollID+"';")
    Debug "Roll ID Exists? (Should ALWAYS be > 0 now): "+Str(DB_RollID) ;/ Should always be > 0

  EndIf
  
  If DB_RollID > 0
    System\Selected_Roll_ID = DB_RollID
    System\Selected_Roll_ID_Text = AMS_Import\RollID
    Import_AMS(1) ;/ No reloading
    System\Refresh_NavTreeID = 1
    System\ForceSelectRollID = DB_RollID

  EndIf

   System\Refresh_NavTreeID = DB_RollID
   System\Refresh_NavTree_Type = #NavTree_Roll
   System\Refresh_Roll_Information = 1 : System\Showing_Panel = 0 ;/
   
   If System\WindowMinimized = 1
     If RollExisted = 0
       Txt = tTxt(#Str_SuccessfullyimportedAMSfileintoanewroll)+Chr(10)
       If Multi_Site_Mode = 1
         Txt + Chr(10)
         Txt + tTxt(#Str_Site)+": "+Get_Site_Name(System\Default_Site)
       EndIf
       Txt + Chr(10)+tTxt(#Str_RollID)+":"+" "+AMS_Import\RollID
       WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),Txt,3000)
     Else
       Txt = tTxt(#Str_SuccessfullyimportedAMSfileintoanexistingroll)+Chr(10)
       If Multi_Site_Mode = 1
         Txt + Chr(10)
         Txt + tTxt(#Str_Site)+": "+Get_Site_Name(System\Default_Site)
       EndIf
       Txt + Chr(10)+tTxt(#Str_RollID)+":"+" "+AMS_Import\RollID
       WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),Txt,3000)
     EndIf
     
   EndIf
   
   ProcedureReturn 1
;   
EndProcedure
Procedure Import_Monitor()
  Protected Success.i, Chk.s, MyLoop.i
  ;/ QR Code - automatic navigation
  If FileSize("C:\ExportAMS\qrcode.txt") > 0 
    If OpenFile(1, "C:\ExportAMS\qrcode.txt")
      Debug "QR!"
      Chk.s = ReadString(1)
      Chk.s = ReplaceString(Chk,"QR-Code:","")
      If RollInfo\RollID <> Chk
        ForEach NavTree()
          If FindString(UCase(NavTree()\String),UCase(Chk),0) > 0
            SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
            If NavTree()\Type = #NavTree_Site
              System\Last_Drawn_Report_SiteID = NavTree()\SiteID
              System\Last_Drawn_Report_GroupID = -1
              Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
              Show_Window(#Panel_Group_List,#PB_Compiler_Line)
            EndIf
            
            If NavTree()\Type = #NavTree_Group
              System\Last_Drawn_Report_SiteID = NavTree()\SiteID
              System\Last_Drawn_Report_GroupID = NavTree()\GroupID
              Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
              Show_Window(#Panel_Group_List,#PB_Compiler_Line)
            EndIf
            
            If NavTree()\Type = #NavTree_Roll
              Redraw_RollID(NavTree()\RollID)
              Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
            EndIf
            Break
          EndIf 
        Next 
      EndIf
      CloseFile(1)
      DeleteFile("C:\ExportAMS\qrcode.txt")
      Debug Chk
    EndIf
  EndIf
  
  ;/ AMS - Automatic import
  If FileSize(System\ImportPath+"Anilox Manager Import.ams") > 0 ;/ exit if file doesn't exist  ;/DNT 
    ;/ check against previous import
    Chk = MD5FileFingerprint(System\ImportPath+"Anilox Manager Import.ams") + Str(GetFileDate(System\ImportPath+"Anilox Manager Import.ams",#PB_Date_Created)) ;/DNT
    If Chk <> System\LastImportedFile
      Debug "*Auto Import file found*"
      System\LastImportedFile = MD5FileFingerprint(System\ImportPath+"Anilox Manager Import.ams") + Str(GetFileDate(System\ImportPath+"Anilox Manager Import.ams",#PB_Date_Created)) ;/DNT
      Delay(100) ;/ delay to ensure export from Anilox QC has completed
      Success = Import_AMS_Master()
      If Success = 1 ;/ forces delete on automatic mode
        DeleteFile(System\ImportPath+"Anilox Manager Import.ams") ;/DNT
        DeleteFile(System\ImportPath+"Image1.jpg")  ;/DNT
        System\LiveMonitorNextTime = ElapsedMilliseconds() + 2000 ;/ delay of 2 seconds so doesn't grab too much resource
      Else
        System\LiveMonitorNextTime = ElapsedMilliseconds() + 2000 ;/ delay of 10 seconds so doesn't grab too much resource
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure SQL_Load_Examples()
  ;/ List Settings
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Settings"  ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Settings;" ;/DNT
  
  ;/ List Roll Masters
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Roll Masters" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Roll_Master;" ;/DNT
  
  ;/ List Roll Info
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Roll Information records" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Roll_Data;" ;/DNT
  
  ;/ List users
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Users" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Users;" ;/DNT
  
  ;/ List Groups
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Groups" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Groups;" ;/DNT
  
    ;/ List Manufacturers
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Manufacturers" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Manufacturers;" ;/DNT
  
      ;/ List SuitabilityTypes
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Suitabilities" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Suitability;" ;/DNT
  
  ;/ List tables
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "List Tables" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "SELECT name FROM sqlite_master WHERE type='table'; "; ORDER BY name;" ;/DNT
  
  ;/ Show Master Roll for Roll ID 1
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "Display Master Roll ID 1" ;/DNT
  My_SQL_Queries()\Line_Count = 1
  My_SQL_Queries()\Line[1]= "Select * from AMS_Roll_Master WHERE AMS_Roll_Master.ID = '1' ;" ;/DNT
  
  ;/ Show Roll info for Roll ID 1
  AddElement(My_SQL_Queries())
  My_SQL_Queries()\Title = "Select * from AMS_Roll_Master, AMS_Roll_Data WHERE AMS_Roll_Master.ID = '1' and AMS_Roll_Data.RollID = '1';" ;/DNT
  My_SQL_Queries()\Line_Count = 2
  My_SQL_Queries()\Line[1]= "Select * from AMS_Roll_Master, AMS_Roll_Data "   ;/DNT
  My_SQL_Queries()\Line[2]= "WHERE AMS_Roll_Master.ID = '1';"   ;/DNT
  
EndProcedure
Procedure SQL_Set_Example()
  Protected MyLoop

  SelectElement(My_SQL_Queries(),GetGadgetState(#Gad_SQL_Dropdown))
  ClearGadgetItems(#Gad_SQL_Query_Txt)
  For MyLoop = 1 To My_SQL_Queries()\Line_Count
    SetGadgetItemText(#Gad_SQL_Query_Txt,MyLoop,My_SQL_Queries()\Line[MyLoop])
  Next
EndProcedure

Procedure Init_Window_GeneralHistory_Control(RollID.i,HistoryID.l = -1)
  Protected Settings_Event.i, Exit.i, SQL.S, Result.S, Date.S, Type.S, Location.S, Width.i, Height.i, Comments.s
  
  Width.i = 640
  Height = 70
  If HistoryID = -1
    OpenWindow(#Window_GeneralHistory,0,0,Width,Height,tTxt(#Str_Insertaniloxhistoryentry),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))  
  Else
    OpenWindow(#Window_GeneralHistory,0,0,Width,Height,tTxt(#Str_Editaniloxhistoryentry),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))  
  EndIf
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  TextGadget(#Gad_GeneralHistory_Date_Text,4,2,70,18,tTxt(#Str_Date)+":")
  TextGadget(#Gad_GeneralHistory_Type_Text,100,2,70,18,tTxt(#Str_Type))
  TextGadget(#Gad_GeneralHistory_Comments_Text,210,2,320,18,tTxt(#Str_Comment))

  DateGadget(#Gad_GeneralHistory_Date,4,20,90,20,"",Date())
  StringGadget(#Gad_GeneralHistory_Type,100,20,100,20,"")
  StringGadget(#Gad_GeneralHistory_Comments,210,20,420,20,"")
  
  ButtonGadget(#Gad_GeneralHistory_Okay,Width - 150,44,70,20,tTxt(#Str_OK))
  ButtonGadget(#Gad_GeneralHistory_Cancel,Width - 75,44,70,20,tTxt(#Str_Cancel))
  
  SetActiveWindow(#Window_GeneralHistory)
  
  ;/ Retrieve RollID

  ;/ Populate gadgets if HistoryID was passed to procedure
  If HistoryID > -1
    SetGadgetState(#Gad_GeneralHistory_Date,Database_IntQuery("Select Date from AMS_General_History Where ID = "+Str(HistoryID)+";"))
    SetGadgetText(#Gad_GeneralHistory_Type,Database_StringQuery("Select Type from AMS_General_History Where ID = "+Str(HistoryID)+";"))
    SetGadgetText(#Gad_GeneralHistory_Comments,Database_StringQuery("Select Comments from AMS_General_History Where ID = "+Str(HistoryID)+";"))
  Else
    SetGadgetState(#Gad_GeneralHistory_Date,Date())
  EndIf

  Repeat
    Settings_Event = WaitWindowEvent()
    
    Select Settings_Event
      Case #PB_Event_CloseWindow
        Exit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_GeneralHistory_Cancel
            Exit = 1
          Case #Gad_GeneralHistory_Okay
            Exit = 2
        EndSelect
    EndSelect
  Until Exit <> 0
  
  If Exit = 2 ;/ Create / Edit record
    Date = Str(GetGadgetState(#Gad_GeneralHistory_Date))
    Type = "'"+GetGadgetTextMac(#Gad_GeneralHistory_Type)+"'"
    Comments = "'"+GetGadgetTextMac(#Gad_GeneralHistory_Comments)+"'"
    
    If HistoryID =-1 ;/ creating new record
      Database_Update(#Databases_Master,"INSERT INTO AMS_General_History (RollID, Date, Type, Comments) Values ("+Str(RollID)+","+Date+","+Type+","+Comments+")",#PB_Compiler_Line)
    Else ;/ editting exsisting record
      Database_Update(#Databases_Master,"Update AMS_General_History Set Date = "+Date+", Type = "+Type+", Comments = "+Comments+" Where ID = "+Str(HistoryID)+";",#PB_Compiler_Line)
    EndIf
    
    Database_SetRollTimeStamp(RollID)
    
    System\Showing_RollID = 999999
    Redraw_RollID(RollID)

  EndIf
  ;   
  CloseWindow(#Window_GeneralHistory)
  SetActiveWindow(#Window_Main)

EndProcedure

Procedure Init_Window_Readings_Edit(RollID.i, EditType.i = 0, DataType.i = 0, ReadingID.i=-1) ;/ Manages the manual creation & editting of readings
  ;/ EditType: 0 = Insert - > 1 = Overwrite - DataType (0 = Master : 1 = Historical
  
  Protected Settings_Event.i, Exit.i, SQL.S, Result.S, Date.i, Operator.S, Vol1.f, Vol2.f, Vol3.f, Vol4.f, Vol5.f, MyLoop.i, Reading.f, Average.f, Depth.i
  Protected ReadingCount.i, Database.S, Error.i, Txt.S, Count.i, Zerocheck.f
  
  ;/ Datatype of -1 = must identify where input should take place
  If DataType = -1
    DataType = 1 ;/ historical
    txt = GetGadgetItemText(#Gad_RollInfo_Original_List,1,0)
    ;MessageRequester("Automated allocation:","Txt = "+txt+" - Len: "+Str(Len(txt)))
    If txt = ""
      DataType = 0 ; set to reference
    EndIf 
  EndIf

  ;  Debug "Readings Control -  RollID: "+Str(RollID)+" - EditType (Insert(-0) / Overwrite(1): "+Str(DataType)
  ;  Debug "    - DataType (-0 = Master - 1 = Historical): "+Str(DataType)+" - ReadingID:"+ Str(ReadingID)
  
  Protected NewList ReadingCountList.f()
  
  If EditType = #Database_Insert
    ;/ check demo limitations
    ;/ (1) Count # of existing Rolls, if count >= Record limit, prompt that max has been reached end exit procedure [Only for DEMO mode]
    Count = Database_CountQuery("Select Count(*) From AMS_Roll_Data where RollID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line) ;/DNT
    Debug "Records count: "+Str(Count) + " - Record Limit: "+Str(System\Settings_ReadingsLimit)
    
    If System\Settings_ReadingsLimit > 0 And Count => System\Settings_ReadingsLimit
      MessageRequester(tTxt(#Str_Error), tTxt(#Str_Sorry)+", "+tTxt(#Str_Demomodelimitationshavebeenreached)+"("+"=>"+Str(System\Settings_ReadingsLimit)+" "+tTxt(#Str_records)+")")
      ProcedureReturn 
    EndIf
    
    OpenWindow(#Window_Readings,0,0,540,85,tTxt(#Str_Insertvolumereadingentry),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))
  Else
    OpenWindow(#Window_Readings,0,0,540,85,tTxt(#Str_Editvolumereadingentry),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))
  EndIf
  
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  TextGadget(#Gad_Reading_Date_Text,4,14,80,18,tTxt(#Str_Date)+":")
  TextGadget(#Gad_Reading_Examiner_Text,90,14,70,18,tTxt(#Str_Examiner))
  
;  TextGadget(#Gad_Reading_Quantity_Combo_Text,170,2,50,30,"Reading Count:")
  TextGadget(#Gad_Reading_Vol1_Text,222,14,40,18,"Vol 1") ;/DNT
  TextGadget(#Gad_Reading_Vol2_Text,262,14,40,18,"Vol 2") ;/DNT
  TextGadget(#Gad_Reading_Vol3_Text,302,14,40,18,"Vol 3") ;/DNT
  TextGadget(#Gad_Reading_Vol4_Text,342,14,40,18,"Vol 4") ;/DNT
  TextGadget(#Gad_Reading_Vol5_Text,382,14,40,18,"Vol 5") ;/DNT
  
  If System\Settings_Volume_Unit = #Settings_VolumeUnit_BCM
    TextGadget(#Gad_Reading_Volume_Text,430,14,50,18,"(BCM)") ;/DNT
  Else
    TextGadget(#Gad_Reading_Volume_Text,430,14,50,18,"(cm3/m2)") ;/DNT
  EndIf
  
  TextGadget(#Gad_Reading_Depth_Text,490,14,50,18,tTxt(#Str_Depth)) ;/DNT
  
  DateGadget(#Gad_Reading_Date,4,32,80,20,"",Date())
  
  StringGadget(#Gad_Reading_Examiner,90,32,120,20,System\Last_Keyed_Operator)
  
  StringGadget(#Gad_Reading_Vol1,220,32,40,18,"")
  StringGadget(#Gad_Reading_Vol2,260,32,40,18,"")
  StringGadget(#Gad_Reading_Vol3,300,32,40,18,"")
  StringGadget(#Gad_Reading_Vol4,340,32,40,18,"")
  StringGadget(#Gad_Reading_Vol5,380,32,40,18,"")
  StringGadget(#Gad_Reading_Depth,490,32,40,18,"")
  
  TextGadget(#Gad_Reading_Volume,430,32,40,20,":")

  ButtonGadget(#Gad_Reading_Okay,390,61,70,20,tTxt(#Str_Save))
  ButtonGadget(#Gad_Reading_Cancel,462,61,70,20,tTxt(#Str_Cancel))
  
  SetActiveWindow(#Window_Readings)
  
  ;/ If editting an existing entry, populate fields
  
  ;/ Identify Count of active *Set to master* , need to flip between master and history
  ClearList(ReadingCountList())
  
  Average = 0  
  
  Database.S = "AMS_Roll_Master" ;/DNT
  If DataType = 1 : Database.S = "AMS_Roll_Data" : EndIf  ;/DNT
  
  ;/ calculate average reading & populate fields
  If EditType = #Database_Overwrite
    Protected Dim Vol.f(5)
    Select DataType
      Case #Reading_Master
        DatabaseQuery(#Databases_Master, "Select Vol1, Vol2, Vol3, Vol4, Vol5, Depth from "+Database + " Where ID = "+Str(RollID))
        ;Reading = UnitConversion_Volume(Database_FloatQuery("Select Vol"+Str(MyLoop)+" from "+Database + " Where ID = "+Str(RollID),#PB_Compiler_Line)) ;/DNT
      Case #Reading_Historical
        DatabaseQuery(#Databases_Master, "Select Vol1, Vol2, Vol3, Vol4, Vol5, Depth from "+Database + " Where ID = "+Str(ReadingID))
        ;Reading = UnitConversion_Volume(Database_FloatQuery("Select Vol"+Str(MyLoop)+" from "+Database + " Where ID = "+Str(ReadingID),#PB_Compiler_Line)) ;/DNT
    EndSelect
    
    NextDatabaseRow(#Databases_Master)
    For MyLoop = 1 To 5
      Vol(Myloop) = GetDatabaseFloat(#Databases_Master,MyLoop-1)
      Debug "Vol"+Str(Myloop)+" - "+StrF(Vol(MyLoop),1)
    Next
    
    Depth = GetDatabaseLong(#Databases_Master,5)
    
    FinishDatabaseQuery(#Databases_Master)
    
    ReadingCount = 0
    For MyLoop = 1 To 5

      If Vol(MyLoop) > 0
        SetGadgetText(#Gad_Reading_Vol1 + ReadingCount,StrFs(Vol(MyLoop),1))
        AddElement(ReadingCountList())
        ReadingCountList() = Vol(MyLoop)
        ReadingCount + 1
        Average + Vol(MyLoop)
      EndIf
    Next
    If ReadingCount = 0 : ReadingCount = 1 : EndIf
    Average / ReadingCount
    ;If ReadingCount < 5 : For MyLoop = ReadingCount To 4 : DisableGadget(#Gad_Reading_Vol1+MyLoop,1) : Next : EndIf
  EndIf 
  
  ;SetGadgetState(#Gad_Reading_Quantity_Combo,ReadingCount-1)
  If EditType = #Database_Overwrite
    If DataType = #Reading_Master
      SetGadgetState(#Gad_Reading_Date,Database_IntQuery("Select ReadingDate from "+Database+" Where ID = "+Str(System\Selected_Roll_ID)+";")) ;/DNT
      SetGadgetText(#Gad_Reading_Examiner,Database_StringQuery("Select Operator from "+Database+" Where ID = "+Str(System\Selected_Roll_ID)+";")) ;/DNT
      SetGadgetText(#Gad_Reading_Volume,StrFs(Average,1))
      SetGadgetText(#Gad_Reading_Depth,Str(Depth))
    Else ;/ Roll Data
      SetGadgetState(#Gad_Reading_Date,Database_IntQuery("Select ReadingDate from "+Database+" Where ID = "+Str(ReadingID)+";")) ;/DNT
      SetGadgetText(#Gad_Reading_Examiner,Database_StringQuery("Select Operator from "+Database+" Where ID = "+Str(ReadingID)+";")) ;/DNT
      SetGadgetText(#Gad_Reading_Volume,StrFs(Average,1))
      SetGadgetText(#Gad_Reading_Depth,Str(Depth))
    EndIf
  Else
    Debug "Setting Default values for Insert"
    SetGadgetState(#Gad_Reading_Date,Date())
    ;SetGadgetText(#Gad_Reading_Examiner,"") ;/DNT
    SetGadgetText(#Gad_Reading_Volume,"0.0") ;/DNT
;    SetGadgetState(#Gad_Reading_Quantity_Combo,0)
;    For MyLoop = 1 To 4 : DisableGadget(#Gad_Reading_Vol1+MyLoop,1) : Next 
  EndIf
  
  If GetGadgetText(#Gad_Reading_Examiner) = ""
    SetActiveGadget(#Gad_Reading_Examiner)
  Else
    SetActiveGadget(#Gad_Reading_Vol1)
  EndIf
  
  Flush_Keys()
  
  ;/ Main Loop
  
  Repeat
    Settings_Event = WaitWindowEvent()
    
    Select Settings_Event
      Case #PB_Event_CloseWindow
        Exit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_Reading_Cancel
            Exit = 1
          Case #Gad_Reading_Okay
            ;/ Check validity of input, question if any zeros
            Error = 0
            ZeroCheck.f = 0
            For MyLoop = 0 To 4
              Zerocheck + Abs(ValFs(GetGadgetTextMac(#Gad_Reading_Vol1+MyLoop)))
            Next
            If ZeroCheck = 0 : Error = 3 : EndIf
            
            For MyLoop = 0 To 4
              If ValFs(GetGadgetTextMac(#Gad_Reading_Vol1+MyLoop)) = 0 And GetGadgetTextMac(#Gad_Reading_Vol1+MyLoop) <> ""
                Error = 1
              EndIf
            Next
            
            If GetGadgetTextMac(#Gad_Reading_Examiner) = ""
              Error = 2
            EndIf

            If Error = 0
              Exit = 2
            Else
              If Error = 1 : MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Cannotsave)+" - "+tTxt(#Str_Oneormorefieldsdonotcontainnumerics),#PB_MessageRequester_Ok) : EndIf
              If Error = 2 : MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Cannotsave)+" - "+tTxt(#Str_Requiresanoperatorname),#PB_MessageRequester_Ok) : EndIf
              If Error = 3 : MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Cannotsave)+" - "+tTxt(#Str_Requiresatleastonevolumereadingentry),#PB_MessageRequester_Ok) : EndIf
            EndIf 
            
          Case #Gad_Reading_Vol1 To #Gad_Reading_Vol5
            Average = 0  : ReadingCount = 0 : Reading = 0
            ;            If GetGadgetState(#Gad_Reading_Quantity_Combo) < 5
            ;Debug "Value of Combo: "+Str(GetGadgetState(#Gad_Reading_Quantity_Combo))
            For MyLoop = 0 To 4 
              ;If MyLoop < (GetGadgetState(#Gad_Reading_Quantity_Combo)+1)
              ;Debug "Checking Vol: "+Str(MyLoop) + " Reading: "+StrF(ValF(GetGadgetTextMac(#Gad_Reading_Vol1+(MyLoop))))
              If ValFs(GetGadgetTextMac(#Gad_Reading_Vol1+(MyLoop))) > 0
                Reading + ValFs(GetGadgetTextMac(#Gad_Reading_Vol1+(MyLoop)))
                ReadingCount + 1
              EndIf
              
              ;                EndIf
              Average = Reading / ReadingCount
              SetGadgetText(#Gad_Reading_Volume,StrF(Average,1))
            Next
            ;            EndIf         
            
        EndSelect
    EndSelect
    
    If GetAsyncKeyState_(#VK_RETURN)
      ;/ Check validity of input, question if any zeros
      Error = 0
      ZeroCheck.f = 0
      For MyLoop = 0 To 4
        Zerocheck + Abs(ValFs(GetGadgetTextMac(#Gad_Reading_Vol1+MyLoop)))
      Next
      If ZeroCheck = 0 : Error = 3 : EndIf
      
      For MyLoop = 0 To 4
        If ValFs(GetGadgetTextMac(#Gad_Reading_Vol1+MyLoop)) = 0 And GetGadgetTextMac(#Gad_Reading_Vol1+MyLoop) <> ""
          Error = 1
        EndIf
      Next
      
      If GetGadgetTextMac(#Gad_Reading_Examiner) = ""
        Error = 2
      EndIf
      
      If Error = 0
        Exit = 2
      Else
        If Error = 1 : MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Cannotsave)+" - "+tTxt(#Str_Oneormorefieldsdonotcontainnumerics),#PB_MessageRequester_Ok) : EndIf
        If Error = 2 : MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Cannotsave)+" - "+tTxt(#Str_Requiresanoperatorname),#PB_MessageRequester_Ok) : EndIf
        If Error = 3 : MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Cannotsave)+" - "+tTxt(#Str_Requiresatleastonevolumereadingentry),#PB_MessageRequester_Ok) : EndIf
      EndIf 
      Repeat : Until GetAsyncKeyState_(#VK_RETURN) = 0
    EndIf
    
    
  Until Exit > 0
  
  ; EditType: 0 = Insert - > 1 = Overwrite - DataType (-0 = Master - 1 = Historical
  
  If Exit = 2 ;/ Create / Edit record
    Date = GetGadgetState(#Gad_Reading_Date)
    Operator = GetGadgetTextMac(#Gad_Reading_Examiner)
    System\Last_Keyed_Operator = GetGadgetText(#Gad_Reading_Examiner)
    ;    ReadingCount = GetGadgetState(#Gad_Reading_Quantity_Combo) + 1
    Protected Dim Vol.f(5)
    ReadingCount = 0
    
    If ValFs(GetGadgetTextMac(#Gad_Reading_Vol1)) > 0
      ReadingCount + 1
      Vol(ReadingCount) = ValFs(GetGadgetTextMac(#Gad_Reading_Vol1))  
    EndIf
    If ValFs(GetGadgetTextMac(#Gad_Reading_Vol2)) > 0
      ReadingCount + 1
      Vol(ReadingCount) = ValFs(GetGadgetTextMac(#Gad_Reading_Vol2))  
    EndIf
    If ValFs(GetGadgetTextMac(#Gad_Reading_Vol3)) > 0
      ReadingCount + 1
      Vol(ReadingCount) = ValFs(GetGadgetTextMac(#Gad_Reading_Vol3))  
    EndIf
    If ValFs(GetGadgetTextMac(#Gad_Reading_Vol4)) > 0
      ReadingCount + 1
      Vol(ReadingCount) = ValFs(GetGadgetTextMac(#Gad_Reading_Vol4))  
    EndIf
    If ValFs(GetGadgetTextMac(#Gad_Reading_Vol5)) > 0
      ReadingCount + 1
      Vol(ReadingCount) = ValFs(GetGadgetTextMac(#Gad_Reading_Vol5))  
    EndIf
    Depth = Val(GetGadgetTextMac(#Gad_Reading_Depth))  

    ;     
    If DataType = #Reading_Master ;/ Master Data - No insert, only overwrite
      ;/ remove current master data
      Database_Update(#Databases_Master,"Update AMS_Roll_Master SET Vol1 = 0, Vol2 = 0, Vol3 = 0, Vol4 = 0, Vol5 = 0 Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
      Debug "ReadingCount: "+Str(ReadingCount)
      Txt.S = "Update AMS_Roll_Master SET "  ;/DNT
      Select ReadingCount
        Case 1
          Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol3 = "+StrF(Vol(1),2) ;/DNT
        Case 2
          Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol2 = "+StrF(Vol(1),2)+", Vol4 = "+StrF(Vol(2),2) ;/DNT
        Case 3
          Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol3 = "+StrF(Vol(2),2)+", Vol5 = "+StrF(Vol(3),2) ;/DNT
        Case 4
          Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol2 = "+StrF(Vol(2),2)+", Vol4 = "+StrF(Vol(3),2)+", Vol5 = "+StrF(Vol(4),2) ;/DNT
        Case 5
          Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol2 = "+StrF(Vol(2),2)+", Vol3 = "+StrF(Vol(3),2)+", Vol4 = "+StrF(Vol(4),2)+", Vol5 = "+StrF(Vol(5),2) ;/DNT
      EndSelect
      
      Txt.S + ", Depth = "+Str(Depth)+" Where ID = "+Str(System\Selected_Roll_ID)+";" ;/DNT
      
    Else ;/ Updating / Inserting on History Data
      If EditType = #Database_Overwrite
        ;/ updating current historical record
        ;Database_Update(#Databases_Master,"Update AMS_Roll_Data SET Vol1 = 0, Vol2 = 0, Vol3 = 0, Vol4 = 0, Vol5 = 0 Where ID = "+Str(ReadingID)+";",#PB_Compiler_Line)
        ;/ remove current value settings
        
        Txt.S = "Update AMS_Roll_Data SET " ;/DNT
        Select ReadingCount
          Case 1
            ;Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol3 = "+StrF(Vol(1),2) ;/DNT
            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = 0, Vol2 = 0, Vol3 = "+StrF(Vol(1),2)+", Vol4 = 0, Vol5 = 0" ;/DNT
          Case 2
;           Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol2 = "+StrF(Vol(1),2)+", Vol4 = "+StrF(Vol(2),2) ;/DNT
            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = 0, Vol2 = "+StrF(Vol(1),2)+", Vol3 = 0, Vol4 = "+StrF(Vol(2),2)+", Vol5 = 0" ;/DNT
          Case 3
;            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol3 = "+StrF(Vol(2),2)+", Vol5 = "+StrF(Vol(3),2) ;/DNT
            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol2 = 0, Vol3 = "+StrF(Vol(2),2)+", Vol4 = 0, Vol5 = "+StrF(Vol(3),2) ;/DNT
          Case 4
;            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol2 = "+StrF(Vol(2),2)+", Vol4 = "+StrF(Vol(3),2)+", Vol5 = "+StrF(Vol(4),2) ;/DNT
            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol2 = "+StrF(Vol(2),2)+", Vol3 = 0, Vol4 = "+StrF(Vol(3),2)+", Vol5 = "+StrF(Vol(4),2) ;/DNT
          Case 5
            Txt.S + "ReadingDate = "+Str(Date)+", Operator = '"+Operator+"', Vol1 = "+StrF(Vol(1),2)+", Vol2 = "+StrF(Vol(2),2)+", Vol3 = "+StrF(Vol(3),2)+", Vol4 = "+StrF(Vol(4),2)+", Vol5 = "+StrF(Vol(5),2) ;/DNT
        EndSelect
        
        Txt.S + ", Depth = "+Str(Depth)+" Where ID = "+Str(ReadingID)+";" ;/DNT
        
      Else ;/ must be creating a new history data set
        Select ReadingCount
          Case 1
            Txt.S = "Insert into AMS_Roll_Data(RollID, ReadingDate, Operator, Vol3, Depth) VALUES (" ;/DNT
          Case 2
            Txt.S = "Insert into AMS_Roll_Data(RollID, ReadingDate, Operator, Vol2, Vol4, Depth) VALUES (" ;/DNT
          Case 3
            Txt.S = "Insert into AMS_Roll_Data(RollID, ReadingDate, Operator, Vol1, Vol3, Vol5, Depth) VALUES (" ;/DNT
          Case 4
            Txt.S = "Insert into AMS_Roll_Data(RollID, ReadingDate, Operator, Vol1, Vol2, Vol4, Vol5, Depth) VALUES (" ;/DNT
          Case 5
            Txt.S = "Insert into AMS_Roll_Data(RollID, ReadingDate, Operator, Vol1, Vol2, Vol3, Vol4, Vol5, Depth) VALUES (" ;/DNT
        EndSelect
        
        
        Select ReadingCount
          Case 1
            Txt.S + Str(System\Selected_Roll_ID)+", " + Str(Date)+", '"+Operator+"', "+StrF(Vol(1),2)+", "+Str(Depth) ;/DNT
          Case 2
            Txt.S + Str(System\Selected_Roll_ID)+", " + Str(Date)+", '"+Operator+"', "+StrF(Vol(1),2)+", "+StrF(Vol(2),2)+", "+Str(Depth) ;/DNT
          Case 3
            Txt.S + Str(System\Selected_Roll_ID)+", " + Str(Date)+", '"+Operator+"', "+StrF(Vol(1),2)+", "+StrF(Vol(2),2)+", "+StrF(Vol(3),2)+", "+Str(Depth) ;/DNT
          Case 4
            Txt.S + Str(System\Selected_Roll_ID)+", " + Str(Date)+", '"+Operator+"', "+StrF(Vol(1),2)+", "+StrF(Vol(2),2)+", "+StrF(Vol(3),2)+", "+StrF(Vol(4),2)+", "+Str(Depth) ;/DNT
          Case 5
            Txt.S + Str(System\Selected_Roll_ID)+", " + Str(Date)+", '"+Operator+"', "+StrF(Vol(1),2)+", "+StrF(Vol(2),2)+", "+StrF(Vol(3),2)+", "+StrF(Vol(4),2)+", "+StrF(Vol(5),2)+", "+Str(Depth) ;/DNT
        EndSelect
        
        Txt.S + ")"+";"
        
      EndIf
    EndIf
    Database_Update(#Databases_Master,Txt.S,#PB_Compiler_Line)
    ;/ Set last reading date to today
    Database_Update(#Databases_Master,"UPDATE AMS_Roll_Master SET LastReadingDate = "+Str(Date())+" Where ID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
    
    Database_SetRollTimeStamp(System\Selected_Roll_ID)
;    Database_SetGroupTimeStamp(System\Selected_Group)

  EndIf

  ;   System\Refresh_Roll_Information = 1 : System\Showing_Panel = 0 ;/
  
  ;   
  CloseWindow(#Window_Readings)
  SetActiveWindow(#Window_Main)
  
  System\Showing_RollID = 999999
  Redraw_RollID(RollID)
  
  ProcedureReturn 1
  
EndProcedure
Procedure Init_Roll_GroupAssign(RollID.i, Site.i)
  Protected Settings_Event.i, Exit.i, SQL.S, Result.S
  
  SQL.S = "Select GroupName, ID From AMS_Groups Where SiteID = '"+Str(Site)+"';"

  ClearList(GroupList())
  
  ;/ Populate Group List
  If DatabaseQuery(#Databases_Master,SQL.S)
    
    While NextDatabaseRow(#Databases_Master)  
      AddElement(GroupList())
      Result.S = GetDatabaseString(#Databases_Master,0) 
      GroupList()\Name = Result
      GroupList()\ID = GetDatabaseLong(#Databases_Master,1)
      Debug "Adding: "+Result+" To Grouplist ("+Str(GroupList()\ID)+")"
    Wend 
  Else
    MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" "+SQL, DatabaseError())
    FinishDatabaseQuery(#Databases_Master)
    ProcedureReturn 
  EndIf
  
  OpenWindow(#Window_GroupAssign,0,0,200,60,tTxt(#Str_Assignrolltogroup),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))  
  TextGadget(#AssignGroup_Text,8,6,70,18,tTxt(#Str_Selectgroup)+":")
  ComboBoxGadget(#AssignGroup_Combo,76,4,120,20)
  
  ForEach GroupList()
    Debug "Adding Group: "+ GroupList()\Name
    AddGadgetItem(#AssignGroup_Combo,-1,GroupList()\Name)  
  Next
  SetGadgetState(#AssignGroup_Combo,0)
  
  ButtonGadget(#AssignGroup_Okay,90,34,50,20,tTxt(#Str_OK))
  ButtonGadget(#AssignGroup_Cancel,142,34,50,20,tTxt(#Str_Cancel))
  
  SetActiveWindow(#Window_GroupAssign)
  
  Repeat
    Settings_Event = WaitWindowEvent()
    
    Select Settings_Event
      Case #PB_Event_CloseWindow
        Exit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #AssignGroup_Cancel
            Exit = 1
          Case #AssignGroup_Okay
            Exit = 2
        EndSelect
    EndSelect
  Until Exit <> 0
  
  If Exit = 2 ;/ Set New RollID Here
    SelectElement(GroupList(),GetGadgetState(#AssignGroup_Combo))
    Database_Reassign_Roll(RollID,GroupList()\ID)
    Redraw_RollID(RollID)
    Redraw_NavTree()
    NavTree_SetToRollID(RollID)
    Database_SetRollTimeStamp(RollID)
  EndIf
  
  CloseWindow(#Window_GroupAssign)
  SetActiveWindow(#Window_Main)

EndProcedure
Procedure.i Init_Password_Requester()
  Protected Event.i, Exit.i, ResultS.s
  OpenWindow(#Window_PasswordRequester,0,0,260,30,tTxt(#Str_PleaseenterPasscodeformanagermode)+":",#PB_Window_WindowCentered,WindowID(#Window_Main))
  StringGadget(#Gad_Password_String,80,4,100,20,"",#PB_String_Password|#PB_String_UpperCase)
  AddKeyboardShortcut(#Window_PasswordRequester, #PB_Shortcut_Return, 0)
  SetActiveGadget(#Gad_Password_String)
  
  Repeat
    Event.i = WaitWindowEvent()
    
    If Event = #PB_Event_Menu And EventMenu() = 0
      Exit = 1
    EndIf
    
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case #Gad_Password_OK
          Exit = 1
      EndSelect
    EndIf

  Until Exit > 0

  ResultS = EncryptCode(UCase(GetGadgetText(#Gad_Password_String)),"OpenWindow")
  CloseWindow(#Window_PasswordRequester)

  If ResultS = "EP+bEg9oIE9+5XWokjSBueElvB8YHh28kJNePjByE5HhJbwfGB4dvJCTXj4wchOR4SW8HxgeHbyQk14+MHITkQ==" ;/ TRO1KA
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf

EndProcedure

Procedure Init_Code_Input(Type.i) ;/ shows current code, and allows input of other (Would control demo -> release mode)
  ;/ Type = 0 = Import
  ;/ Type = 1 = Export
  
  Protected CurrentCode.s, NewCode.s, Code.s, OkayCount.i, CheckLoop.i, ChecksumString.s
  Protected Code_Event.i, Width.i, Height.i, Exit.i, Error.i, ErrorText.S, X.i, Y.i
  Protected ResultS.S, Resulti.i, DeleteFlag.i, OldCode.s, Rep.s
  Protected Dim CodeString.s(10)

  Width.i = 610 : Height.i = 160
  OpenWindow(#Window_Code,0,0,Width,Height,tTxt(#Str_AMS)+" - "+tTxt(#Str_Codechanger),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))
  StickyWindow(#Window_Code,1)
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  
  If Type = 1 ;/ Export
    CurrentCode = Database_StringQuery("Select Code from AMS_Settings;")+Chr(10)
    CurrentCode + Database_StringQuery("Select Location from AMS_CompanyInfo;")+Chr(10)
    CurrentCode + Database_StringQuery("Select Country from AMS_CompanyInfo;")+Chr(10)
    CurrentCode + Database_StringQuery("Select ContactName from AMS_CompanyInfo;")+Chr(10)
    CurrentCode + Database_StringQuery("Select ContactEmail from AMS_CompanyInfo;")+Chr(10)
    CurrentCode + Database_StringQuery("Select ContactNumber from AMS_CompanyInfo;");+Chr(10)
    TextGadget(#Gad_Code_Current_Text,4,4,50,20,tTxt(#Str_Current)+":")
    EditorGadget(#Gad_Code_Current,4,24,600,100)
    SetGadgetText(#Gad_Code_Current,CurrentCode)
    ButtonGadget(#Gad_Code_Cancel,Width-70,Height-24,60,20,tTxt(#Str_OK))
  Else ;/ Import
    TextGadget(#Gad_Code_New_Text,4,4,50,20,tTxt(#Str_New)+":")
    EditorGadget(#Gad_Code_New_String,4,24,600,100)
    ButtonGadget(#Gad_Code_Save,Width-140,Height-24,60,20,tTxt(#Str_Save))
    ;DisableGadget(#Gad_Code_Save,1)
    ButtonGadget(#Gad_Code_Cancel,Width-70,Height-24,60,20,tTxt(#Str_Cancel))
  EndIf
  
  Repeat
    Code_Event = WaitWindowEvent()
    
    Select Code_Event
      Case #PB_Event_CloseWindow
        Exit = 2
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_Code_Save
            Exit = 1
            ;/ Verify Code & Save
            If Len(GetGadgetTextMac(#Gad_Code_New_String)) > 0
              CurrentCode = GetGadgetTextMac(#Gad_Code_New_String)
              ChecksumString = ""
              For CheckLoop = 1 To 7          
                CodeString(CheckLoop) = StringField(Currentcode,CheckLoop,Chr(10))
                If Checkloop < 7
                  ChecksumString + CodeString(CheckLoop)
                Else ;/ Checksum is Read
                  Codestring(7) = ReplaceString(Codestring(7),Chr(10),"")
                  Codestring(7) = ReplaceString(Codestring(7),Chr(13),"")
                  Debug "RHS: "+Str(Asc(Right(Codestring(7),1)))
                EndIf
                Debug CodeString(CheckLoop)
                ;  Debug "Len: "+Str(Len(ChecksumString)
              Next
              Debug "Len: "+Str(Len(ChecksumString))
              
              ;/ Check Checksum string
              Debug "Checksum: "+MD5Fingerprint(@ChecksumString, Len(ChecksumString))
              If CodeString(7) = MD5Fingerprint(@ChecksumString, Len(ChecksumString))
                ;/ Save Here
                ;/ Main Code
                If StringField(DecryptCode(FormatTextMac(CodeString(1)),"OpenWindow"),1,Chr(10)) = "ARK" ;/DNT
                  Database_Update(#Databases_Master,"UPDATE AMS_Settings SET Code='"+FormatTextMac(CodeString(1))+"';",#PB_Compiler_Line)
                EndIf
                ;/Location
                If StringField(DecryptCode(FormatTextMac(CodeString(2)),"OpenWindow"),1,Chr(10)) = "ARK" ;/DNT
                  Database_Update(#Databases_Master,"UPDATE AMS_CompanyInfo SET Location = '"+FormatTextMac(CodeString(2))+"';",#PB_Compiler_Line)
                EndIf
                ;/Country
                If StringField(DecryptCode(FormatTextMac(CodeString(3)),"OpenWindow"),1,Chr(10)) = "ARK" ;/DNT
                  Database_Update(#Databases_Master,"UPDATE AMS_CompanyInfo SET Country = '"+FormatTextMac(CodeString(3))+"';",#PB_Compiler_Line)
                EndIf   
                ;/Contact Name
                If StringField(DecryptCode(FormatTextMac(CodeString(4)),"OpenWindow"),1,Chr(10)) = "ARK" ;/DNT
                  Database_Update(#Databases_Master,"UPDATE AMS_CompanyInfo SET ContactName = '"+FormatTextMac(CodeString(4))+"';",#PB_Compiler_Line)
                EndIf                 
                ;/Contact Email
                If StringField(DecryptCode(FormatTextMac(CodeString(5)),"OpenWindow"),1,Chr(10)) = "ARK" ;/DNT
                  Database_Update(#Databases_Master,"UPDATE AMS_CompanyInfo SET ContactEmail = '"+FormatTextMac(CodeString(5))+"';",#PB_Compiler_Line)
                EndIf                  
                ;/Contact Number
                If StringField(DecryptCode(FormatTextMac(CodeString(6)),"OpenWindow"),1,Chr(10)) = "ARK" ;/DNT
                  Database_Update(#Databases_Master,"UPDATE AMS_CompanyInfo SET ContactNumber = '"+FormatTextMac(CodeString(6))+"';",#PB_Compiler_Line)
                EndIf
                
                SelectElement(Navtree(),1)
                If Navtree()\String = "Orion Flexo"
                  Database_Update(#Databases_Master,"UPDATE AMS_Sites SET Name = '"+FormatTextMac(DeCodeI(CodeString(2)))+"';",#PB_Compiler_Line)
                EndIf
                
                Delay(500)
                Database_LoadSettings()
                System\Language_Update = 1
                
              Else
                Delay(2000)
                MessageRequester(tTxt(#Str_Error),tTxt(#Str_Codeincorrect)+" - "+tTxt(#Str_Pleasetryagain))
              EndIf
            EndIf
         
        Case #Gad_Code_Cancel
          Exit = 1
          
      EndSelect
  EndSelect
  
Until Exit > 0

  CloseWindow(#Window_Code)
  SetActiveWindow(#Window_Main)

EndProcedure
Procedure Init_Site_Info(SiteID.i, Info_Only.i=0)
  Protected Event.i, Width.i, Height.i, Exit.i, Error.i, ErrorText.S, X.i, Y.i
  Protected ResultS.S, Resulti.i, DeleteFlag.i, SQL.s, CountI.i, DateI.i
  Protected NewList GroupList_Temp.i()
  
  ;/ populate Group list
  SQL.S = "Select ID From AMS_Groups Where SiteID = '"+Str(SiteID)+"';"
  ClearList(GroupList_Temp())
  DatabaseQuery(#Databases_Master,SQL.S)
  While NextDatabaseRow(#Databases_Master)  
    AddElement(GroupList_Temp())
    GroupList_Temp() = GetDatabaseLong(#Databases_Master,0) 
  Wend 
  
  Width.i = 320 : Height.i = 400
  OpenWindow(#Window_SiteInfo,0,0,Width,Height,tTxt(#Str_AMS)+" - "+tTxt(#Str_Siteinfo)+", "+tTxt(#Str_forsite)+":"+" "+Str(SiteID),#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  StickyWindow(#Window_SiteInfo,1)
  EditorGadget(#Gad_SiteInfo_Editor,4,4,width-8,height-32)
  ButtonGadget(#Gad_SiteInfo_Okay,Width-100,Height-24,90,20,tTxt(#Str_OK))

  ResultS = Database_StringQuery("Select Name from AMS_Sites where ID = "+Str(Siteid))
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Siteinformation)+":")
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,"")
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Sitename)+":"+" "+ResultS)
  ResultS = Database_StringQuery("Select Location from AMS_Sites where ID = "+Str(Siteid))
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Location)+":"+" "+ResultS)
  ResultS = Database_StringQuery("Select Country from AMS_Sites where ID = "+Str(Siteid))
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Country)+":"+" "+ResultS)
  ResultS = Database_StringQuery("Select ContactName from AMS_Sites where ID = "+Str(Siteid))
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Contactname)+":"+" "+ResultS)
  ResultS = Database_StringQuery("Select ContactNumber from AMS_Sites where ID = "+Str(Siteid))
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Contactnumber)+":"+" "+ResultS)
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,"")
  ResultI = Database_CountQuery("Select Count(*) from AMS_Groups where SiteID = "+Str(Siteid),#PB_Compiler_Line)
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Groupcount)+":"+" "+Str(ResultI))
  
  CountI = 0
  ForEach GroupList_Temp()
    CountI + Database_CountQuery("Select Count(*) from AMS_Roll_Master where GroupID = "+Str(GroupList_Temp()),#PB_Compiler_Line)
  Next
  
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Rollsassignedtogroups)+":"+" "+Str(CountI))
  
  CountI = 0 : DateI.i = Date()-604800
  ForEach GroupList_Temp()
    CountI + Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate > "+Str(DateI)+" and "+tTxt(#Str_GroupID)+" "+"= "+Str(GroupList_Temp()),#PB_Compiler_Line) ;/DNT
  Next
  
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Rollsscannedinlast7days)+":"+" "+Str(CountI))
  
  
  CountI = 0 : DateI.i = Date()-604800
  ForEach GroupList_Temp()
    CountI + Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate < "+Str(DateI)+" and "+tTxt(#Str_GroupID)+" "+"= "+Str(GroupList_Temp()),#PB_Compiler_Line) ;/DNT
  Next
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Notscannedfor7days)+":"+" "+Str(CountI))
  
  CountI = 0 : DateI.i = Date()-2419200
  ForEach GroupList_Temp()
    CountI + Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate < "+Str(DateI)+" and "+tTxt(#Str_GroupID)+" "+"= "+Str(GroupList_Temp()),#PB_Compiler_Line)
  Next
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Notscannedfor4weeks)+":"+" "+Str(CountI))
  
  CountI = 0 : DateI.i = Date()-7257600
  ForEach GroupList_Temp()
    CountI + Database_CountQuery("Select Count(*) from AMS_Roll_Master where LastReadingDate < "+Str(DateI)+" and "+tTxt(#Str_GroupID)+" "+"= "+Str(GroupList_Temp()),#PB_Compiler_Line)
  Next
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,tTxt(#Str_Notscannedfor12weeks)+":"+" "+Str(CountI))
  
  
  AddGadgetItem(#Gad_SiteInfo_Editor,-1,"----------------------------------------------------------------------")
  
  Repeat
    Event = WaitWindowEvent()
    
    Select Event
      Case #PB_Event_CloseWindow
        Exit = 2
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_SiteInfo_Okay
            Exit = 1
        EndSelect
    EndSelect
    
  Until Exit > 0

  CloseWindow(#Window_SiteInfo)
  SetActiveWindow(#Window_Main)

EndProcedure
Procedure Init_CS_Editor(SiteID.i) ;/ 0 = company, >0 = Site
  Protected MyEvent.i, Width.i, Height.i, X.i, Y.i, Exit.i, SQL.s
  
  Width.i = 320
  Height = 170
    
  If SiteID = 0
    Debug "Editting Company details"
    OpenWindow(#Window_CompanySiteEditor,0,0,Width,Height,tTxt(#Str_Editcompanydetails),#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  Else
    Debug "Editting Site Details: "+Str(siteID)
    OpenWindow(#Window_CompanySiteEditor,0,0,Width,Height,tTxt(#Str_Editsitedetails),#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  EndIf
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  StickyWindow(#Window_CompanySiteEditor,1)
  SetActiveWindow(#Window_CompanySiteEditor)
  Flush_Events()
  
  X = 10 : Y = 10
  
  TextGadget(#Gad_CSEdit_Location_Text,X,Y+4,100,20,tTxt(#Str_Location)+":")
  X + 100
  StringGadget(#Gad_CSEdit_Location,X,Y,120,20,"")
  X - 100 : Y + 24
  
  TextGadget(#Gad_CSEdit_Country_Text,X,Y+4,100,20,tTxt(#Str_Country)+":")
  X + 100
  StringGadget(#Gad_CSEdit_Country,X,Y,120,20,"")
  X - 100 : Y + 24
  
  TextGadget(#Gad_CSEdit_Name_Text,X,Y+4,100,20,tTxt(#Str_Contactname)+":")
  X + 100
  StringGadget(#Gad_CSEdit_Name,X,Y,200,20,"")
  X - 100 : Y + 24
  
  TextGadget(#Gad_CSEdit_Email_Text,X,Y+4,100,20,tTxt(#Str_Contactemail)+":")
  X + 100
  StringGadget(#Gad_CSEdit_Email,X,Y,200,20,"")
  X - 100 : Y + 24
  
  TextGadget(#Gad_CSEdit_Number_Text,X,Y+4,100,20,tTxt(#Str_Contactnumber)+":")
  X + 100
  StringGadget(#Gad_CSEdit_Number,X,Y,200,20,"")
  X - 100 : Y + 24

  ;/ Populate gadgets based on Company / site
  If SiteID = 0 ;/ company
    SetGadgetText(#Gad_CSEdit_Location,Database_StringQuery("Select Location from AMS_CompanyInfo")) ;/DNT
    SetGadgetText(#Gad_CSEdit_Country ,Database_StringQuery("Select Country from AMS_CompanyInfo")) ;/DNT
    SetGadgetText(#Gad_CSEdit_Name ,Database_StringQuery("Select ContactName from AMS_CompanyInfo")) ;/DNT
    SetGadgetText(#Gad_CSEdit_Number ,Database_StringQuery("Select ContactNumber from AMS_CompanyInfo")) ;/DNT
    SetGadgetText(#Gad_CSEdit_Email ,Database_StringQuery("Select ContactEmail from AMS_CompanyInfo")) ;/DNT
  Else ;/ Site
;    SetGadgetText(#Gad_CSEdit_Name,Database_StringQuery("Select Name from AMS_Sites where ID = "+Str(Siteid)))
    SetGadgetText(#Gad_CSEdit_Location,Database_StringQuery("Select Location from AMS_Sites where ID = "+Str(Siteid))) ;/DNT
    SetGadgetText(#Gad_CSEdit_Country ,Database_StringQuery("Select Country from AMS_Sites where ID = "+Str(Siteid))) ;/DNT
    SetGadgetText(#Gad_CSEdit_Name ,Database_StringQuery("Select ContactName from AMS_Sites where ID = "+Str(Siteid))) ;/DNT
    SetGadgetText(#Gad_CSEdit_Number ,Database_StringQuery("Select ContactNumber from AMS_Sites where ID = "+Str(Siteid))) ;/DNT
    SetGadgetText(#Gad_CSEdit_Email ,Database_StringQuery("Select ContactEmail from AMS_Sites where ID = "+Str(Siteid))) ;/DNT
  EndIf
  
  
  ButtonGadget(#Gad_CSEdit_Save,Width - 160,Height-25,70,20,tTxt(#Str_Save))
  ButtonGadget(#Gad_CSEdit_Cancel,Width - 80,Height-25,70,20,tTxt(#Str_Cancel))
  
  
  Exit = 0 
  Repeat
    MyEvent = WaitWindowEvent()
    
    Select  MyEvent
      Case #PB_Event_CloseWindow
        Exit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_CSEdit_Save
            Exit = 2
          Case #Gad_CSEdit_Cancel
            Exit = 1
        EndSelect
    EndSelect

  Until Exit > 0

  If Exit = 2 ;/ Save
    If SiteID  = 0 ;/ Company
      SQL.s = "Update AMS_CompanyInfo Set " ;/DNT
      SQL.s + "ContactName = '"+GetGadgetText(#Gad_CSEdit_Name)+"', " ;/DNT
      SQL.s + "Location = '"+GetGadgetText(#Gad_CSEdit_Location)+"', " ;/DNT
      SQL.s + "Country = '"+GetGadgetText(#Gad_CSEdit_Country)+"', " ;/DNT
      SQL.s + "Contactnumber = '"+GetGadgetText(#Gad_CSEdit_Number)+"', " ;/DNT
      SQL.s + "ContactEmail = '"+GetGadgetText(#Gad_CSEdit_Email)+"'" ;/DNT

      Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)
      
      Redraw_HomeScreen()
      Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
    Else ;/ Site
      SQL.s = "Update AMS_Sites Set "
      SQL.s + "ContactName = '"+GetGadgetText(#Gad_CSEdit_Name)+"', " ;/DNT
      SQL.s + "Location = '"+GetGadgetText(#Gad_CSEdit_Location)+"', " ;/DNT
      SQL.s + "Country = '"+GetGadgetText(#Gad_CSEdit_Country)+"', " ;/DNT
      SQL.s + "Contactnumber = '"+GetGadgetText(#Gad_CSEdit_Number)+"', " ;/DNT
      SQL.s + "ContactEmail = '"+GetGadgetText(#Gad_CSEdit_Email)+"'" ;/DNT
      
      SQL + " Where ID = "+Str(SiteID) ;/DNT
      
      Database_Update(#Databases_Master,SQL,#PB_Compiler_Line)
      
      Redraw_HomeScreen()
      Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
    EndIf
    
  EndIf
    
  CloseWindow(#Window_CompanySiteEditor)
  
EndProcedure

Procedure Init_Settings()
  ;/ Code to be changed so that options are set from database *!*
  Protected Settings_Event.i, Width.i, Height.i, Exit.i, Error.i, ErrorText.S, X.i, Y.i, DatabaseID.i
  Protected ResultS.S, Resulti.i, DeleteFlag.i, MyLoop.i, SelectedLanguage.i, LanguageChange.i
  
  Width.i = 480 : Height.i = 220

  OpenWindow(#Window_Settings,0,0,Width,Height,tTxt(#Str_AMS)+" - "+tTxt(#Str_Settings),#PB_Window_WindowCentered|#PB_Window_SystemMenu|#PB_Window_Invisible,WindowID(#Window_Main))

  StickyWindow(#Window_Settings,1)
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  FrameGadget(#Settings_Gad_SectionList_Frame,4,4,Width-8,Height-30,"")
  TreeGadget(#Settings_Gad_SectionList,8,16,192,height-50)

  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_General),0,0)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Language),0,1)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Dateformat),0,1)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Measurementunits),0,1)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Importoptions),0,1)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Warningtriggers),0,0)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Variancewarningvalues),0,1)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Capacitywarningvalues),0,1)
  
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Databaselists),0,0)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Manufacturerlist),0,1)
  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Suitabilitytypes),0,1)
  
  If Multi_Site_Mode = 1
    ;/ add multi site options to settings window
    AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_MultiSite),0,0)
    AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_MultiSiteSettings),0,1)
    x = 210  : y = 30
    ;Framegadget(#Settings_MultiSite_Frame,X-4,4,Width-8,30,"",#PB_Frame3D_Single)

;     TextGadget(#Settings_MultiSite_DatabasePath_Text,x+14,y,120,20,tTxt(#STR_DatabasePath)+":") : y + 20
;     ButtonGadget(#Settings_MultiSite_DatabasePath,x+14,Y,240,20,System\Database_Path) : Y + 30

    Refresh_Site_List()
    
    TextGadget(#Settings_MultiSite_DefaultSite_Text,x+14,y,100,20,tTxt(#STR_DefaultSite)+":")
    ComboBoxGadget(#Settings_MultiSite_DefaultSite,x+120,y,120,20) : Y + 30
    
    ForEach SiteList()
      AddGadgetItem(#Settings_MultiSite_DefaultSite,-1,SiteList()\Text)
      If SiteList()\ID = System\Default_Site
        SetGadgetState(#Settings_MultiSite_DefaultSite,ListIndex(SiteList()))
      EndIf
    Next

    CheckBoxGadget(#Settings_MultiSite_ShowDefaultOnly,X+14,y,200,20,tTxt(#STR_ShowSelectedSiteOnly)+"?") : Y + 30
    SetGadgetState(#Settings_MultiSite_ShowDefaultOnly,System\DefaultOnly)
    
    TextGadget(#Settings_MultiSite_PollingInterval_Text,x+14,y,70,20,tTxt(#STR_Pollinterval)+":") 
    SpinGadget(#Settings_MultiSite_PollingInterval,x+90,y-2,40,20,5,60,#PB_Spin_Numeric)
    SetGadgetState(#Settings_MultiSite_PollingInterval,System\PollingInterval)
    TextGadget(#Settings_MultiSite_Seconds_Text,x+130,y,70,20,":"+tTxt(#Str_Seconds)) ;/TD set to seconds text
  EndIf
  
;  AddGadgetItem(#Settings_Gad_SectionList,-1,tTxt(#Str_Serversettings),0,0)
  
  x = 210
  ;Framegadget(#Settings_Gad_Language_Frame,X-4,4,Width-8,30,"",#PB_Frame3D_Single)
  TextGadget(#Settings_Gad_Language_Combo_Text,x+14,24,60,20,tTxt(#Str_Language)+":")
  ComboBoxGadget(#Settings_Gad_Language_Combo,x+90,22,140,20)
  
  ForEach LangMaster()
    AddGadgetItem(#Settings_Gad_Language_Combo,-1,LangMaster()\Language)
  Next
  
  ForEach LangMaster()
    If LangMaster()\Language = System\Settings_Language
      SetGadgetState(#Settings_Gad_Language_Combo,ListIndex(LangMaster()))
      SelectedLanguage = ListIndex(Langmaster())
      Break
    EndIf
  Next
  
  TextGadget(#Settings_Gad_Language_CSVDelimiter_Text,x+14,58,120,40,tTxt(#Str_CSVExportDelimiter)+":")
  ComboBoxGadget(#Settings_Gad_Language_CSVDelimiter,x+14+122,56,90,20)
  AddGadgetItem(#Settings_Gad_Language_CSVDelimiter,-1,tTxt(#STR_Comma))
  AddGadgetItem(#Settings_Gad_Language_CSVDelimiter,-1,tTxt(#STR_Tab))
  SetGadgetState(#Settings_Gad_Language_CSVDelimiter,System\CSVDelimiter)
  
  TextGadget(#Settings_Gad_Language_DecimalNotation_Text,x+14,102,120,20,tTxt(#Str_NotationCharacter)+":")
  ComboBoxGadget(#Settings_Gad_Language_DecimalNotation,x+14+122,100,90,20)
  AddGadgetItem(#Settings_Gad_Language_DecimalNotation,-1,tTxt(#STR_DecimalPoint))
  AddGadgetItem(#Settings_Gad_Language_DecimalNotation,-1,tTxt(#STR_Comma))
  SetGadgetState(#Settings_Gad_Language_DecimalNotation,System\DecimalNotation)
  
  FrameGadget(#Settings_Gad_Unit_Frame,x,24,236,100,tTxt(#Str_Measurementunits))
  TextGadget(#Settings_Gad_Unit_Screen_Text,x+14,44,110,20,tTxt(#Str_Screenunits)+":")
  ComboBoxGadget(#Settings_Gad_Unit_Screen_Combo,x+138,42,80,20)
  AddGadgetItem(#Settings_Gad_Unit_Screen_Combo,-1,"LPI") ;/DNT
  AddGadgetItem(#Settings_Gad_Unit_Screen_Combo,-1,"LPCM") ;/DNT

  TextGadget(#Settings_Gad_Unit_Volume_Text,x+14,70,110,20,tTxt(#Str_Volumeunits)+":")
  ComboBoxGadget(#Settings_Gad_Unit_Volume_Combo,x+138,68,80,20)
  AddGadgetItem(#Settings_Gad_Unit_Volume_Combo,-1,"cm3/m2") ;/DNT
  AddGadgetItem(#Settings_Gad_Unit_Volume_Combo,-1,"BCM") ;/DNT

  TextGadget(#Settings_Gad_Unit_Length_Text,x+14,96,110,20,tTxt(#Str_Lengthunits)+":")
  ComboBoxGadget(#Settings_Gad_Unit_Length_Combo,x+138,94,80,20)
  AddGadgetItem(#Settings_Gad_Unit_Length_Combo,-1,tTxt(#Str_Metric))
  AddGadgetItem(#Settings_Gad_Unit_Length_Combo,-1,tTxt(#Str_Imperial))

  ;Framegadget(#Settings_Gad_DateFormat_Frame,x,4,236,30,"",2)
  TextGadget(#Settings_Gad_DateFormat_Text,x+14,24,80,20,tTxt(#Str_Dateformat)+":")
  ComboBoxGadget(#Settings_Gad_DateFormat_Combo,x+100,22,100,20)
  AddGadgetItem(#Settings_Gad_DateFormat_Combo,-1,tTxt(#Str_DDMMYYYY))
  AddGadgetItem(#Settings_Gad_DateFormat_Combo,-1,tTxt(#Str_MMDDYYYY))
  
  X = 210 : Y = 30
  
  TextGadget(#Settings_Gad_Import_Directory_Text,X,Y,80,20,tTxt(#Str_Importpath)+":"); : Y + 20
  ButtonGadget(#Settings_Gad_Import_Directory,X+80,Y,170,20,System\ImportPath) : Y + 24
;  TextGadget(#Settings_Gad_Import_Database_Directory_Text,X,Y,100,20,tTxt(#Str_DatabasePath)+":") : Y + 20
;  ButtonGadget(#Settings_Gad_Import_Database_Directory,X+10,Y,260,20,System\Database_Path) : Y + 24
  
  CheckBoxGadget(#Settings_Gad_Import_AutoToggle,x+6,y,250,20,tTxt(#Str_Enableautomaticimport)+"?") : Y + 24
  CheckBoxGadget(#Settings_Gad_Import_DeleteAfter,x+6,y,250,20,tTxt(#Str_Deleteafterimport)+"?") : Y + 24
  CheckBoxGadget(#Settings_Gad_Import_ShowReadingDepth,x+6,y,250,20,tTxt(#Str_ShowReadingDepths)+"?") : Y + 24
  
  X = 210 : Y = 24
  FrameGadget(#Settings_Unit_Warnings_Frame,X,Y,Width-248,100,tTxt(#Str_Warningvalues)+"("+"%"+")")
  TextGadget(#Settings_Unit_Warnings_Variance_Text,X+80,Y+16,70,20,tTxt(#Str_Variance)+":")
  TextGadget(#Settings_Unit_Warnings_Capacity_Text,X+80,Y+16,60,20,tTxt(#Str_Capacity)+":")
  TextGadget(#Settings_Unit_Warnings_Good_Text,X+6,Y+36,70,20,tTxt(#Str_Good)+":",#PB_Text_Right)
  TextGadget(#Settings_Unit_Warnings_Okay_Text,X+6,Y+56,70,20,tTxt(#Str_OK)+":",#PB_Text_Right)
  TextGadget(#Settings_Unit_Warnings_Bad_Text,X+6,Y+76,70,20,tTxt(#Str_Bad)+":",#PB_Text_Right)

  StringGadget(#Settings_Unit_Warnings_Variance_Good,X+80,Y+34,40,20,"",#PB_String_Numeric) : SetGadgetColor(#Settings_Unit_Warnings_Variance_Good,#PB_Gadget_FrontColor,#Database_Colour_Good)
  TextGadget(#Settings_Unit_Warnings_Variance_Okay,X+82,Y+56,40,20,tTxt(#Str_OK)) : SetGadgetColor(#Settings_Unit_Warnings_Variance_Okay,#PB_Gadget_FrontColor,#Database_Colour_Okay)
  StringGadget(#Settings_Unit_Warnings_Variance_Bad,X+80,Y+74,40,20,"",#PB_String_Numeric) : SetGadgetColor(#Settings_Unit_Warnings_Variance_Bad,#PB_Gadget_FrontColor,#Database_Colour_Bad)
  
  StringGadget(#Settings_Unit_Warnings_Capacity_Good,X+80,Y+34,40,20,"",#PB_String_Numeric) : SetGadgetColor(#Settings_Unit_Warnings_Capacity_Good,#PB_Gadget_FrontColor,#Database_Colour_Good)
  TextGadget(#Settings_Unit_Warnings_Capacity_Okay,X+82,Y+56,40,20,tTxt(#Str_OK)) : SetGadgetColor(#Settings_Unit_Warnings_Capacity_Okay,#PB_Gadget_FrontColor,#Database_Colour_Okay)
  StringGadget(#Settings_Unit_Warnings_Capacity_Bad,X+80,Y+74,40,20,"",#PB_String_Numeric) : SetGadgetColor(#Settings_Unit_Warnings_Capacity_Bad,#PB_Gadget_FrontColor,#Database_Colour_Bad)
  
  X = 210 :  Y = 24
  FrameGadget(#Settings_Manufacturer_Frame,X,Y,236,126,tTxt(#Str_Manufacturerlist))
  ListViewGadget(#Settings_Manufacturer_List,X+4,Y+16,140,104)

  ClearGadgetItems(#Settings_Manufacturer_List)
  ForEach ManufacturerList()
    If ListIndex(ManufacturerList()) > 0
      AddGadgetItem(#Settings_Manufacturer_List,-1,ManufacturerList()\Text)  
    EndIf
  Next

  ButtonGadget(#Settings_Manufacturer_New,X+150,Y+16,80,20,tTxt(#Str_New))
  ButtonGadget(#Settings_Manufacturer_Edit,X+150,Y+38,80,20,tTxt(#Str_Edit))
  ButtonGadget(#Settings_Manufacturer_Delete,X+150,Y+60,80,20,tTxt(#Str_Delete))

  X = 210 :  Y = 24
  FrameGadget(#Settings_Suitability_Frame,X,Y,236,126,tTxt(#Str_Suitabilitytypes))
  ListViewGadget(#Settings_Suitability_List,X+4,Y+16,140,104)
  
  ForEach SuitabilityList()
    If ListIndex(SuitabilityList()) > 0
      AddGadgetItem(#Settings_Suitability_List,-1,SuitabilityList()\Text)  
    EndIf
  Next
  
  ButtonGadget(#Settings_Suitability_New,X+150,Y+16,80,20,tTxt(#Str_New))
  ButtonGadget(#Settings_Suitability_Edit,X+150,Y+38,80,20,tTxt(#Str_Edit))
  ButtonGadget(#Settings_Suitability_Delete,X+150,Y+60,80,20,tTxt(#Str_Delete))

;   ;/ set gadget states to match settings values
;   For MyLoop = 0 To CountGadgetItems(#Settings_Gad_Language_Combo)
;     If GetGadgetItemText(#Settings_Gad_Language_Combo,MyLoop)
;       SetGadgetState(#Settings_Gad_Language_Combo,MyLoop)  
;       Break
;     EndIf
;   Next
  
  SetGadgetState(#Settings_Gad_Unit_Screen_Combo,System\Settings_Screen_Unit)  
  SetGadgetState(#Settings_Gad_Unit_Volume_Combo,System\Settings_Volume_Unit)  
  SetGadgetState(#Settings_Gad_Unit_Length_Combo,System\Settings_Length_Unit)
  SetGadgetState(#Settings_Gad_DateFormat_Combo,System\Settings_Date_Format)

  SetGadgetText(#Settings_Unit_Warnings_Variance_Good,Str(System\Settings_Variance_Good))
  SetGadgetText(#Settings_Unit_Warnings_Variance_Bad,Str(System\Settings_Variance_Bad))
  SetGadgetText(#Settings_Unit_Warnings_Capacity_Good,Str(System\Settings_Capacity_Good))
  SetGadgetText(#Settings_Unit_Warnings_Capacity_Bad,Str(System\Settings_Capacity_Bad))
  
  SetGadgetState(#Settings_Gad_Import_AutoToggle,System\LiveMonitor)
  SetGadgetText(#Settings_Gad_Import_Directory,System\ImportPath)
  SetGadgetState(#Settings_Gad_Import_DeleteAfter,System\DeleteAfterImport)
  SetGadgetState(#Settings_Gad_Import_ShowReadingDepth,System\Show_Depth)
  
  If System\LiveMonitor = 1 ;/ Force deletion on?
    SetGadgetState(#Settings_Gad_Import_DeleteAfter,1)
  EndIf

;  Framegadget(#Settings_Gad_Connection_Frame,4,x,Width-8,90,"Network Connection [Multi-Site only]")
  
  ButtonGadget(#Settings_Gad_Okay,Width-80, Height - 24,70,20,tTxt(#Str_OK))
;  ButtonGadget(#Settings_Gad_Cancel,Width-80,Height - 25,70,20,"Cancel")
  
  ;/ Hide All Gadgets
  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
  Next
;   ;/ Now show relevant gadgets
;   For MyLoop = #Settings_Gad_Language_Start To #Settings_Gad_Language_End
;     If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
;   Next
  
  HideWindow(#Window_Settings,0)
  SetActiveWindow(#Window_Settings)
  
  Repeat
    Settings_Event = WaitWindowEvent()
    
    Select Settings_Event
      Case #PB_Event_CloseWindow
        Exit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Settings_Gad_Language_Combo
            If GetGadgetState(#Settings_Gad_Language_Combo) <> SelectedLanguage
              LanguageChange = 1
              SelectedLanguage = GetGadgetState(#Settings_Gad_Language_Combo)
              
              ForEach LangMaster()
                If LangMaster()\Language = GetGadgetText(#Settings_Gad_Language_Combo)
                  Break
                EndIf
              Next
              System\Language_Current_File = LanguagesDirectory+LangMaster()\FileName
              System\Language_Current_Element = ListIndex(LangMaster())            
              
;              CloseDatabase(#Databases_Language)
            EndIf
            
          Case #Settings_Gad_Language_CSVDelimiter
            Debug "CSV update: "+Str(GetGadgetState(#Settings_Gad_Language_CSVDelimiter))
            Debug System\Language_Current_File
            If OpenDatabase(#Databases_Language,System\Language_Current_File,"","",#PB_Database_SQLite)
            Database_Update(#Databases_Language,"Update AMS_Language_Master SET CSVDelimiter = "+Str(GetGadgetState(#Settings_Gad_Language_CSVDelimiter))+";",#PB_Compiler_Line)
            System\CSVDelimiter = GetGadgetState(#Settings_Gad_Language_CSVDelimiter)
            CloseDatabase(#Databases_Language)
          Else
            Debug "Error: "+DatabaseError()
          EndIf
          
          Case #Settings_Gad_Language_DecimalNotation
            Debug "Decimal notation update: "+Str(GetGadgetState(#Settings_Gad_Language_DecimalNotation))
            Debug System\Language_Current_File
            If OpenDatabase(#Databases_Language,System\Language_Current_File,"","",#PB_Database_SQLite)
              Database_Update(#Databases_Language,"Update AMS_Language_Master SET DecimalNotation = "+Str(GetGadgetState(#Settings_Gad_Language_DecimalNotation))+";",#PB_Compiler_Line)
              System\DecimalNotation = GetGadgetState(#Settings_Gad_Language_DecimalNotation)
              CloseDatabase(#Databases_Language)
            Else
              Debug "Error: "+DatabaseError()
            EndIf
          Case #Settings_Gad_SectionList
            If EventType() = #PB_EventType_LeftClick
            If GetGadgetState(#Settings_Gad_SectionList) > -1
              Select GetGadgetState(#Settings_Gad_SectionList)
                  
                Case #Settings_Field_Language
                  ;/ Hide All Gadgets
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next
                  ;/ Now show relevant gadgets
                  For MyLoop = #Settings_Gad_Language_Start To #Settings_Gad_Language_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                  Next
                  
                Case #Settings_Field_DateFormat
                  ;/ Hide All Gadgets
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next
                  ;/ Now show relevant gadgets
                  For MyLoop = #Settings_Gad_DateFormat_Start To #Settings_Gad_DateFormat_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                  Next
                  
                Case #Settings_Field_MeasurementsUnits
                  ;/ Hide All Gadgets
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next
                  ;/ Now show relevant gadgets
                  For MyLoop = #Settings_Gad_Unit_Start To #Settings_Gad_Unit_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                  Next 
                  
                Case #Settings_Field_Variance_WarningValues
                  If Check_Manager_Mode()
                    ;/ Hide All Gadgets
                    For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                    Next
                    ;/ Now show relevant gadgets
                    For MyLoop = #Settings_Unit_Warnings_Start To #Settings_Unit_Warnings_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                    Next
                    For MyLoop = #Settings_Unit_Warnings_Variance_Start To #Settings_Unit_Warnings_Variance_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                    Next
                  EndIf
                  
                Case #Settings_Field_Capacity_WarningValues
                  If Check_Manager_Mode()
                    ;/ Hide All Gadgets
                    For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                    Next
                    ;/ Now show relevant gadgets
                    For MyLoop = #Settings_Unit_Warnings_Start To #Settings_Unit_Warnings_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                    Next
                    For MyLoop = #Settings_Unit_Warnings_Capacity_Start To #Settings_Unit_Warnings_Capacity_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                    Next  
                  EndIf
                  
                Case #Settings_Field_ManufacturerList
                  ;/ Hide All Gadgets
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next
                  For MyLoop = #Settings_Manufacturer_Start To #Settings_Manufacturer_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                  Next  
                  
                Case #Settings_Field_SuitabilityTypes
                  ;/ Hide All Gadgets
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next
                  For MyLoop = #Settings_Suitability_Start To #Settings_Suitability_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                  Next 
                  
                Case #Settings_Field_LiveMonitoring
                  ;/ Hide All Gadgets
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next
                  For MyLoop = #Settings_Gad_Import_Start To #Settings_Gad_Import_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                  Next 

                Case #Settings_Field_MultiSiteSettings
                  If Check_Manager_Mode()
                    ;/ Hide All Gadgets
                    For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                    Next
                    For MyLoop = #Settings_MultiSite_Start To #Settings_MultiSite_End
                      If IsGadget(MyLoop) : HideGadget(MyLoop,0) : EndIf
                    Next 
                  EndIf
                Default
                  For MyLoop = #Settings_Gad_Hide_Start To #Settings_Gad_Hide_End
                    If IsGadget(MyLoop) : HideGadget(MyLoop,1) : EndIf
                  Next

              EndSelect
              EndIf
            EndIf
          Case #Settings_Gad_Import_Directory
            ResultS = PathRequester(tTxt(#Str_Selectimportpath), System\ImportPath)    
            If ResultS <> ""
              SetGadgetText(#Settings_Gad_Import_Directory, ResultS)
            EndIf

          Case #Settings_Manufacturer_New
            ResultS = InputRequester(tTxt(#Str_Newmanufacturer),tTxt(#Str_Enternewmanufacturername),"")
            If ResultS <> ""
              ;/ check for existence
              Resulti = Database_CheckForDuplicate("Select Name from AMS_Manufacturers",ResultS) ;/DNT
              ;/ if it doesn't exist
              If Resulti = 0
                Database_Update(#Databases_Master,"INSERT INTO AMS_Manufacturers (Name) VALUES ('"+ResultS+"')",#PB_Compiler_Line) ;/DNT
                Refresh_Manufacturer_List()
              EndIf
            EndIf
          Case #Settings_Manufacturer_Edit
            If GetGadgetState(#Settings_Manufacturer_List) > -1
              DatabaseID = Get_Manufacturer_Value(GetGadgetItemText(#Settings_Manufacturer_List,GetGadgetState(#Settings_Manufacturer_List)))
              Debug "**** Manufacturer Database ID: "+Str(DatabaseID)

              ;SelectElement(ManufacturerList(),Get_Manufacturer_Index(GetGadgetState(#Settings_Manufacturer_List)))
              ResultS = InputRequester(tTxt(#Str_Editmanufacturer),tTxt(#Str_Editmanufacturername),GetGadgetItemText(#Settings_Manufacturer_List,GetGadgetState(#Settings_Manufacturer_List)))
              If ResultS <> ""
                ;/ check for existence
                Resulti = Database_CheckForDuplicate("Select Name from AMS_Manufacturers",ResultS) ;/DNT
                ;/ if it doesn't exist
                If Resulti = 0
                  Database_Update(#Databases_Master,"Update AMS_Manufacturers SET Name = '"+ResultS+"' Where ID = "+Str(DatabaseID)+";",#PB_Compiler_Line) ;/DNT
                  Refresh_Manufacturer_List()
                EndIf
              EndIf
            EndIf
          Case #Settings_Manufacturer_Delete
            DeleteFlag = 1
            If GetGadgetState(#Settings_Manufacturer_List) > -1
              ;/ Count Roll Master where ID = 
              DatabaseID = Get_Manufacturer_Value(GetGadgetItemText(#Settings_Manufacturer_List,GetGadgetState(#Settings_Manufacturer_List)))
              Debug "**** Manufacturer Database ID: "+Str(DatabaseID)
              
              Resulti = Database_CountQuery("Select Count(*) from AMS_Roll_Master Where Manufacturer = "+Str(DatabaseID),#PB_Compiler_Line) ;/DNT
              If Resulti > 0
                If MessageRequester("Warning","There are "+Str(Resulti)+" Rolls assigned to this manufacturer, Are you Sure?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No ;/DNT
                  DeleteFlag = 0
                EndIf
              EndIf
              
              If DeleteFlag = 1
                
                If Resulti > 0 ;/ reassign to zero
                  Database_Update(#Databases_Master,"Update AMS_Roll_Master Set Manufacturer = 0 Where Manufacturer = "+Str(DatabaseID)+";",#PB_Compiler_Line) ;/DNT
                EndIf
                
                Database_Update(#Databases_Master,"Delete from AMS_Manufacturers where ID = "+Str(DatabaseID)+";",#PB_Compiler_Line) ;/DNT
                Refresh_Manufacturer_List()

              EndIf
            EndIf
          Case #Settings_Gad_Import_Database_Directory
            MS_CheckDatabaseLocation(1)
          Case #Settings_Suitability_New
            ResultS = InputRequester("New Suitability type","Enter new Suitability type","") ;/DNT
            If ResultS <> ""
              ;/ check for existence
              Resulti = Database_CheckForDuplicate("Select Description from AMS_Suitability",ResultS) ;/DNT
              ;/ if it doesn't exist
              If Resulti = 0
                Database_Update(#Databases_Master,"INSERT INTO AMS_Suitability (RollType, Description) VALUES ('1', '"+ResultS+"')",#PB_Compiler_Line) ;/DNT
              EndIf
              Refresh_Suitability_List()

            EndIf
            
          Case #Settings_Suitability_Edit
            If GetGadgetState(#Settings_Suitability_List) > -1
              DatabaseID = Get_Suitability_Value(GetGadgetItemText(#Settings_Suitability_List,GetGadgetState(#Settings_Suitability_List)))
              Debug "*** Suitability ID: "+Str(DatabaseID)
              ;SelectElement(SuitabilityList(),Get_Suitability_Index(GetGadgetState(#Settings_Suitability_List)))
              ResultS = InputRequester("Edit Suitability","Edit Suitability name",GetGadgetItemText(#Settings_Suitability_List,GetGadgetState(#Settings_Suitability_List))) ;/DNT
              If ResultS <> ""
                ;/ check for existence
                Resulti = Database_CheckForDuplicate("Select Description from AMS_Suitability",ResultS) ;/DNT
                ;/ if it doesn't exist
                If Resulti = 0
                  Database_Update(#Databases_Master,"Update AMS_Suitability SET Description = '"+ResultS+"' Where ID = "+Str(DatabaseID)+";",#PB_Compiler_Line) ;/DNT
                  Refresh_Suitability_List()
                EndIf
              EndIf
            EndIf
          Case #Settings_Suitability_Delete
            DeleteFlag = 1
            If GetGadgetState(#Settings_Suitability_List) > -1
              DatabaseID = Get_Suitability_Value(GetGadgetItemText(#Settings_Suitability_List,GetGadgetState(#Settings_Suitability_List)))
              Debug "*** Suitability ID: "+Str(DatabaseID)
              ;/ Count Roll Master where ID = 
              ;SelectElement(SuitabilityList(),Get_Suitability_Index(GetGadgetState(#Settings_Suitability_List)))
              Resulti = Database_CountQuery("Select Count(*) from AMS_Roll_Master Where Suitability = "+Str(DatabaseID),#PB_Compiler_Line) ;/DNT
              If Resulti > 0
                If MessageRequester(tTxt(#Str_Warning),tTxt(#Str_Thereare)+Str(Resulti)+" "+"Roll"+"("+"s"+")"+" "+tTxt(#Str_AssignedToThisSuitabilityType)+","+" "+tTxt(#Str_AreyouSure)+"?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
                  DeleteFlag = 0
                EndIf
              EndIf
              
              If DeleteFlag = 1
                
                If Resulti > 0 ;/ reassign to zero
                  Database_Update(#Databases_Master,"Update AMS_Roll_Master Set Suitability = 0 Where Suitability = "+Str(DatabaseID)+";",#PB_Compiler_Line)
                EndIf
                
                Database_Update(#Databases_Master,"Delete from AMS_Suitability where ID = "+Str(DatabaseID)+";",#PB_Compiler_Line)
                Refresh_Suitability_List()
              EndIf
            EndIf
          Case #Settings_Gad_Cancel
            Exit = 1
          Case #Settings_Gad_Okay
            ;/ Sanity check variables
            Error = 0 : ErrorText = ""
            If Val(GetGadgetTextMac(#Settings_Unit_Warnings_Variance_Good)) < 1 : ErrorText + tTxt(#Str_Mustenteravalidnumberinthe)+"'"+tTxt(#Str_Variancegood)+"'"+" "+tTxt(#Str_field)+"." + Chr(10) : Error = 1 : EndIf
            If Val(GetGadgetTextMac(#Settings_Unit_Warnings_Variance_Bad)) < 1 : ErrorText + tTxt(#Str_Mustenteravalidnumberinthe)+"'"+tTxt(#Str_Variancebad)+"'"+" "+tTxt(#Str_field)+"." + Chr(10) : Error = 1  : EndIf
            If Val(GetGadgetTextMac(#Settings_Unit_Warnings_Capacity_Good)) < 1 : ErrorText + tTxt(#Str_Mustenteravalidnumberinthe)+"'"+tTxt(#Str_Capacitygood)+"'"+" "+tTxt(#Str_field)+"." + Chr(10) : Error = 1  : EndIf
            If Val(GetGadgetTextMac(#Settings_Unit_Warnings_Capacity_Bad)) < 1 : ErrorText + tTxt(#Str_Mustenteravalidnumberinthe)+"'"+tTxt(#Str_Capacitybad)+"'"+" "+tTxt(#Str_field)+"." + Chr(10) : Error = 1  : EndIf

            If Val(GetGadgetTextMac(#Settings_Unit_Warnings_Capacity_Bad)) > Val(GetGadgetTextMac(#Settings_Unit_Warnings_Capacity_Good))
              ErrorText + "'"+tTxt(#Str_Capacitybad)+"'"+" "+tTxt(#Str_fieldshouldntexceedthe)+tTxt(#Str_Capacitygood)+"'"+tTxt(#Str_field) + Chr(10) : Error = 1
            EndIf
            
            If Val(GetGadgetTextMac(#Settings_Unit_Warnings_Variance_Good)) > Val(GetGadgetTextMac(#Settings_Unit_Warnings_Variance_Bad))
              ErrorText + "'"+tTxt(#Str_Variancegood)+"'"+" "+tTxt(#Str_fieldshouldntexceedthe)+tTxt(#Str_Variancebad)+"'"+" "+tTxt(#Str_field) + Chr(10) : Error = 1
            EndIf
            
            If Error > 0
              MessageRequester(tTxt(#Str_Error)+"...",ErrorText)
            EndIf
            If Error = 0
              Exit = 2
            EndIf
        EndSelect
    EndSelect
    
    If LanguageChange = 1
      Debug "Language Change"
      LanguageChange = 0
      OpenDatabase(#Databases_Language,System\Language_Current_File,"","",#PB_Database_SQLite)
      DatabaseQuery(#Databases_Language, "Select CSVDelimiter, DecimalNotation From AMS_Language_Master;")
      NextDatabaseRow(#Databases_Language) ;/ only one row, so no need for while / 
      System\CSVDelimiter = GetDatabaseLong(#Databases_Language,0)
      System\DecimalNotation = GetDatabaseLong(#Databases_Language,1)
      SetGadgetState(#Settings_Gad_Language_CSVDelimiter,System\CSVDelimiter)
      SetGadgetState(#Settings_Gad_Language_DecimalNotation,System\DecimalNotation)
      CloseDatabase(#Databases_Language)
    EndIf

  Until Exit <> 0
  
  If Exit = 2 ;/ Save settings here
    ;/ refresh system variables
    
    If GetGadgetItemText(#Settings_Gad_Language_Combo, GetGadgetState(#Settings_Gad_Language_Combo)) <> System\Settings_Language
      System\Language_Update = 1
    EndIf
    
    System\Settings_Language.s = GetGadgetItemText(#Settings_Gad_Language_Combo, GetGadgetState(#Settings_Gad_Language_Combo))
    Debug "Language setting set to: "+System\Settings_Language.s
    System\Settings_Screen_Unit.i = GetGadgetState(#Settings_Gad_Unit_Screen_Combo)
    System\Settings_Length_Unit.i = GetGadgetState(#Settings_Gad_Unit_Length_Combo)
    System\Settings_Volume_Unit.i = GetGadgetState(#Settings_Gad_Unit_Volume_Combo)
    System\Settings_Date_Format.i = GetGadgetState(#Settings_Gad_DateFormat_Combo)
    
    System\Settings_Capacity_Good.i = Val(GetGadgetTextMac(#Settings_Unit_Warnings_Capacity_Good))
    System\Settings_Capacity_Bad.i = Val(GetGadgetTextMac(#Settings_Unit_Warnings_Capacity_Bad))
    
    System\Settings_Variance_Good.i = Val(GetGadgetTextMac(#Settings_Unit_Warnings_Variance_Good))
    System\Settings_Variance_Bad.i = Val(GetGadgetTextMac(#Settings_Unit_Warnings_Variance_Bad))
    
    System\LiveMonitor = GetGadgetState(#Settings_Gad_Import_AutoToggle)
    SetGadgetState(#Gad_AutoImport,System\LiveMonitor)
    System\ImportPath = GetGadgetText(#Settings_Gad_Import_Directory)
    
    System\DeleteAfterImport = GetGadgetState(#Settings_Gad_Import_DeleteAfter)

    If GetGadgetState(#Settings_Gad_Import_ShowReadingDepth) <> System\Show_Depth
      System\Refresh_Roll_Information = 1
      System\Showing_RollID = -1
    EndIf
    
    System\Show_Depth = GetGadgetState(#Settings_Gad_Import_ShowReadingDepth)
    
    If Multi_Site_Mode = 1
      
      If System\Default_Site <> Get_Site_ID(GetGadgetText(#Settings_MultiSite_DefaultSite))
        ;/ force refresh
        System\Refresh_NavTreeID = 1
      EndIf
      
      If System\DefaultOnly <> GetGadgetState(#Settings_MultiSite_PollingInterval)
        ;/ force refresh  
        System\Refresh_NavTreeID = 1
      EndIf

      System\Database_Path = GetGadgetText(#Settings_MultiSite_DatabasePath)
      System\Default_Site = Get_Site_ID(GetGadgetText(#Settings_MultiSite_DefaultSite))
      Debug "Default site set to : "+Str(System\Default_Site)
      
      System\DefaultOnly = GetGadgetState(#Settings_MultiSite_ShowDefaultOnly)
      System\PollingInterval = GetGadgetState(#Settings_MultiSite_PollingInterval)
    EndIf
    
    Tool_TimeTest_Begin()
    Database_SaveSettings()
    Database_LoadSettings()
    Tool_TimeTest_End()

;    MessageRequester("","Time to save settings: "+Str(System\TimeTest)+"ms")
   
    System\Showing_RollID = 0
    Redraw_RollID(System\Last_Drawn_Roll)
    Redraw_Report(System\Last_Drawn_Report_SiteId,System\Last_Drawn_Report_GroupId)
    
  EndIf
  
  CloseWindow(#Window_Settings)
  SetActiveWindow(#Window_Main)

EndProcedure

Procedure Init_Presets(Type.i)
  Protected Presets_Event.i, Width.i, Height.i, Exit.i, Error.i, ErrorText.S, X.i, Y.i
  Protected ResultS.S, Resulti.i, DeleteFlag.i, Txt.s, Editting.i, NoSave.i, SQL.s, Val.i, OldFilter.s
  
  Width.i = 500 : Height.i = 350 : Editting = 0
;
  If type = 2 ;/ Edit
    If GetGadgetState(#Gad_Report_Preset_Combo) = 0
      MessageRequester(tTxt(#Str_Error),tTxt(#Str_Sorry)+", "+tTxt(#Str_youcannoteditthebasepreset),#PB_MessageRequester_Ok)
      ProcedureReturn 
    EndIf
  EndIf

  If type = 3 ;/ Delete
    If GetGadgetState(#Gad_Report_Preset_Combo) = 0
      MessageRequester(tTxt(#Str_Error),tTxt(#Str_Sorry)+", "+tTxt(#Str_youcannotdeletethebasepreset),#PB_MessageRequester_Ok)
      ProcedureReturn 
    EndIf
    
    ;/ Delete Roll
    ResultI = GetGadgetState(#Gad_Report_Preset_Combo)
    If Resulti > 0
      SelectElement(Report_PresetList(),Resulti)
      Editting = Report_PresetList()\ID
      Txt.s = tTxt(#Str_Areyousureyouwanttodeletepreset)+":"+" '"+Report_PresetList()\Name+"'"+"?"
      
      If MessageRequester(tTxt(#Str_Deletepreset)+", "+tTxt(#Str_Areyousure)+"?",Txt,#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
        Database_Update(#Databases_Master,"Delete From AMS_ReportPresets where ID = "+Str(Editting)+";",#PB_Compiler_Line)
        Refresh_Presets_List()
        ProcedureReturn 
      EndIf
      
    EndIf
  EndIf
  
  
  If Type = 1
    If MessageRequester(tTxt(#Str_Question),tTxt(#Str_Doyouwanttouseanexistingqueryasatemplate)+"?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      OpenWindow(#Window_Presets,0,0,320,60,tTxt(#Str_AMS)+" - "+tTxt(#Str_Selectpreset),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))
      ;
      SetGadgetFont(#PB_Default,FontID(#Font_List_S))
      ComboBoxGadget(#Gad_Presets_Name,4,4,312,20)
      ForEach Report_PresetList()
        AddGadgetItem(#Gad_Presets_Name,-1,Report_PresetList()\Name)
      Next
      SetGadgetState(#Gad_Presets_Name,0)
      ButtonGadget(#Gad_Presets_Save,260,38,54,20,tTxt(#Str_OK))
      Exit = 0
      Repeat
        Presets_Event = WaitWindowEvent()
        Select Presets_Event
          Case #PB_Event_CloseWindow
            Exit = 1
          Case #PB_Event_Gadget
            Select EventGadget()
              Case #Gad_Presets_Save
                Exit = 2
            EndSelect
        EndSelect
        
      Until Exit > 0
      
      If Exit = 2 ;/ 'Okay' has been selected
        Type = 4
        ResultI = GetGadgetState(#Gad_Presets_Name)
      EndIf
      CloseWindow(#Window_Presets)
      Repeat : Until WindowEvent() = 0
    EndIf
    
  EndIf
  
  OpenWindow(#Window_Presets,0,0,Width,Height,tTxt(#Str_AMS)+" - "+tTxt(#Str_Presets),#PB_Window_WindowCentered|#PB_Window_SystemMenu,WindowID(#Window_Main))
  StickyWindow(#Window_Presets,1)
  SetGadgetFont(#PB_Default,FontID(#Font_List_Dialogs))
  TextGadget(#Gad_Presets_Name_Text,4,6,80,20,tTxt(#Str_Presettitle)+":")
  StringGadget(#Gad_Presets_Name,90,4,336,20,"")
  
  TextGadget(#Gad_Presets_Query_Text,4,36,80,20,tTxt(#Str_Presetquery)+":")
  EditorGadget(#Gad_Presets_Query,90,34,336,60)
  TextGadget(#Gad_Presets_QueryCount,90,96,336,20,tTxt(#Str_Queryreturnscounts))
  
  TextGadget(#Gad_Presets_RollTable_Text,4,120,120,20,"AMS_Roll_Master") ;/DNT
  TextGadget(#Gad_Presets_SuitabilityTable_Text,128,120,120,20,"AMS_Suitability") ;/DNT
  TextGadget(#Gad_Presets_ManufacturerTable_Text,252,120,120,20,"AMS_Manufacturers") ;/DNT
  
  ListViewGadget(#Gad_Presets_RollTable,4,140,120,160)
  ListViewGadget(#Gad_Presets_SuitabilityTable,128,140,120,160)
  ListViewGadget(#Gad_Presets_ManufacturerTable,252,140,120,160)

  ForEach SuitabilityList()
    Txt.s = Str(SuitabilityList()\ID)+":"+" "+SuitabilityList()\Text
    AddGadgetItem(#Gad_Presets_SuitabilityTable,-1,Txt)
  Next
  
  ForEach ManufacturerList()
    Txt.s = Str(ManufacturerList()\ID)+":"+" "+ManufacturerList()\Text
    AddGadgetItem(#Gad_Presets_ManufacturerTable,-1,Txt)
  Next
  
  DatabaseQuery(#Databases_Master,"pragma table_info(AMS_Roll_Master)")
  While NextDatabaseRow(#Databases_Master)  
    Txt = GetDatabaseString(#Databases_Master,1) 
    AddGadgetItem(#Gad_Presets_RollTable,-1,Txt)
  Wend 
  FinishDatabaseQuery(#Databases_Master)
  
  
  ButtonGadget(#Gad_Presets_Save,Width - 120,Height-24,54,20,tTxt(#Str_Save))
  ButtonGadget(#Gad_Presets_Cancel,Width - 60,Height-24,54,20,tTxt(#Str_Cancel))

  SetActiveWindow(#Window_Presets)
  
  If Type = 4 ;/ New - But adopted preset
    If Resulti > 0
      SelectElement(Report_PresetList(),Resulti)
      SetGadgetText(#Gad_Presets_Name,tTxt(#Str_New)+" - "+Report_PresetList()\Name)
      SetGadgetText(#Gad_Presets_query,Report_PresetList()\SQL)
      Type = 1
    EndIf
  EndIf
  
  If Type = 2 ;/ Edit
    ResultI = GetGadgetState(#Gad_Report_Preset_Combo)
    If Resulti > 0
      SelectElement(Report_PresetList(),Resulti)
      Editting = Report_PresetList()\ID
      SetGadgetText(#Gad_Presets_Name,Report_PresetList()\Name)
      SetGadgetText(#Gad_Presets_query,Report_PresetList()\SQL)
    EndIf
  EndIf
  Exit = 0
  Repeat
    Presets_Event = WaitWindowEvent()
    
    Select Presets_Event
      Case #PB_Event_CloseWindow
        Exit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gad_Presets_Query
            If OldFilter <> GetGadgetText(#Gad_Presets_Query)
              OldFilter = GetGadgetText(#Gad_Presets_Query)
              SQL.s = "Select Count(*) From (Select * From AMS_Roll_Master,AMS_Groups Where AMS_Roll_Master.GroupID = AMS_Groups.ID and AMS_Groups.SiteID = 1) where "
              SQL.s +  ReplaceString( GetGadgetText(#Gad_Presets_Query),"/DATE/",Str(Date()))  ;/DNT
              Val = Database_CountQuery(SQL,#PB_Compiler_Line,1)
              SetGadgetText(#Gad_Presets_QueryCount,tTxt(#Str_Thequeryreturned)+Str(val) +" "+tTxt(#Str_results)+".")
            EndIf
          
          Case #Gad_Presets_Cancel
            Exit = 1
          Case #Gad_Presets_Save
            NoSave = 0
            If GetGadgetText(#Gad_Presets_Name) = "" : MessageRequester(tTxt(#Str_Error),tTxt(#Str_Youmustenterapresetname),#PB_MessageRequester_Ok) : NoSave = 1 : EndIf
            If GetGadgetText(#Gad_Presets_Query) = "" : MessageRequester(tTxt(#Str_Error),tTxt(#Str_Youmustenterapresetquery),#PB_MessageRequester_Ok) : NoSave = 1 : EndIf
            If NoSave = 0
            Exit = 2
            EndIf 
        EndSelect
        
    EndSelect
  Until Exit <> 0
  
  If Exit = 2
    If Editting > 0
      Database_Update(#Databases_Master,"Update AMS_ReportPresets Set Name = '"+GetGadgetText(#Gad_Presets_Name)+"', SQL = '"+GetGadgetText(#Gad_Presets_Query)+"' Where ID = "+Str(Editting),#PB_Compiler_Line)
      Refresh_Presets_List()
    Else
      ;/ Is new entry
      Database_Update(#Databases_Master,"Insert into AMS_ReportPresets (Name, SQL) VALUES ('"+GetGadgetText(#Gad_Presets_Name)+"', '"+GetGadgetText(#Gad_Presets_Query)+"')",#PB_Compiler_Line)
      Refresh_Presets_List()
    EndIf
  EndIf
  
  CloseWindow(#Window_Presets)
  SetActiveWindow(#Window_Main)

EndProcedure
Procedure.i AssignScale(Gadget.i,ScaleX.i=1,ScaleY.i=1,ScalePosX.i=1,ScalePosY.i=1,Minx.i=0,Miny.i=0,Maxx.i=0,Maxy.i=0)
  
  Protected InAlready.i, ColumnCount.i
  
  If IsGadget(Gadget) = 0 : ProcedureReturn : EndIf 
  
  InAlready = 0
  ForEach GadgetScale()
    If GadgetScale()\Gadget = Gadget : InAlready = ListIndex(GadgetScale()) : Break : EndIf 
  Next
  
  If InAlready = 0 : AddElement(GadgetScale()) : EndIf 
  
  With GadgetScale()
    \Gadget = Gadget 
    \ScaleX = ScaleX
    \ScaleY = ScaleY
    \ScalePosX = ScalePosX
    \ScalePosY = ScalePosY
    \Minx = Minx
    \Miny = Miny
    \Maxx = Maxx
    \Maxy = Maxy
    \KeyPosX = GadgetX(Gadget)
    \KeyPosY = GadgetY(Gadget)
    \KeySizeX = GadgetWidth(Gadget)
    \KeySizeY = GadgetHeight(Gadget)
    
    ;/ 
    If GetGadgetFont(Gadget) = FontID(#Font_List_XS)  : \FontID = #Font_List_XS  : EndIf
    If GetGadgetFont(Gadget) = FontID(#Font_List_S)  : \FontID = #Font_List_S  : EndIf
    If GetGadgetFont(Gadget) = FontID(#Font_List_M)  : \FontID = #Font_List_M  : EndIf
    If GetGadgetFont(Gadget) = FontID(#Font_List_L)  : \FontID = #Font_List_L  : EndIf
    If GetGadgetFont(Gadget) = FontID(#Font_List_L_Bold)  : \FontID = #Font_List_L_Bold  : EndIf
    If GetGadgetFont(Gadget) = FontID(#Font_List_XL) : \FontID = #Font_List_XL : EndIf
    
    If GadgetType(\Gadget) = #PB_GadgetType_Image 
      \KeepRatio = 1
    EndIf
    
    ;/ Overrides
    If \Gadget = #Gad_RollInfo_Roll_Image Or \Gadget = #Gad_RollInfo_Roll_Pins
      \KeepRatio = 0
    EndIf
    If \Gadget = #Gad_RollInfo_Comment_Box
      \FontID = #Font_List_S
    EndIf
    
    
    If GadgetType(\Gadget) = #PB_GadgetType_ListIcon
      ColumnCount = 0
;      While GetGadgetItemAttribute(\Gadget, 0,  #PB_ListIcon_ColumnWidth, ColumnCount)
        Repeat
        ;Debug GetGadgetItemAttribute(\Gadget, 0,  #PB_ListIcon_ColumnWidth, ColumnCount)
        \ColumnSize[ColumnCount] = GetGadgetItemAttribute(\Gadget,0,#PB_ListIcon_ColumnWidth,ColumnCount)
        ColumnCount + 1
      Until GetGadgetItemAttribute(\Gadget, 0,  #PB_ListIcon_ColumnWidth, ColumnCount) = 0 Or GetGadgetItemAttribute(\Gadget, 0,  #PB_ListIcon_ColumnWidth, ColumnCount)=1997758947
      \ColumnCount = ColumnCount
    EndIf
    
  EndWith
  
EndProcedure
Procedure AssignScaleToAll()
  ;/ loops through all existing gadgets, calling assignscale() to all valid gadgets
  Protected MyLoop.i
  For MyLoop = 0 To 999999
    If IsGadget(MyLoop)
      AssignScale(MyLoop)
    EndIf
  Next
EndProcedure
Procedure ResizeGadgets()
  Protected WinX.i, WinY.i, X.i, Y.i, W.i, H.i, ScaleX.f, ScaleY.f, ScaleMin.f, MyLoop.i
  Protected WinWidth.i, WinHeight.i
  Protected  r.RECT
  
  WinWidth = WindowWidth(#Window_Main)
  WinHeight = WindowHeight(#Window_Main)
  
  Debug "Rescaling Window"
  
  ScaleX.f = WinWidth / WinInfo\WinXMin
  ScaleY.f = WinHeight / WinInfo\WinYMin
  
  ScaleMin = ScaleX
  If ScaleY < Scalex : ScaleMin = ScaleY : EndIf
  Scalemin * 1.01
  
  Debug "ScaleMin: "+StrF(ScaleMin,3)
  If ScaleMin < 1 : ScaleMin = 1 : EndIf 
  
  LoadFont(#Font_List_XS, System\Font_Name, System\Font_Size_XS * ScaleMin,#PB_Font_HighQuality) ;/ #Font_List_XS
  LoadFont(#Font_List_S, System\Font_Name,  System\Font_Size_S  * ScaleMin,#PB_Font_HighQuality) ;/ #Font_List_S
  LoadFont(#Font_List_M, System\Font_Name,  System\Font_Size_M  * ScaleMin,#PB_Font_Bold|#PB_Font_HighQuality) ;/ #Font_List_M 
  LoadFont(#Font_List_L, System\Font_Name,  System\Font_Size_L  * ScaleMin,#PB_Font_HighQuality) ;/ #Font_List_L 
  LoadFont(#Font_List_L_Bold, System\Font_Name,  System\Font_Size_L  * ScaleMin,#PB_Font_Bold|#PB_Font_HighQuality) ;/ #Font_List_L 
  LoadFont(#Font_List_XL, System\Font_Name, System\Font_Size_XL * ScaleMin,#PB_Font_HighQuality) ;/ #Font_List_L 
  
  ForEach GadgetScale()
    
    With GadgetScale()
      
      If \KeepRatio = 0
        X = \KeyPosX * ScaleX
        Y = \KeyPosY * ScaleY
        W = \KeySizeX * ScaleX
        H = \KeySizeY * ScaleY
        SetGadgetFont(\Gadget,FontID(\FontID))
        ResizeGadget(\Gadget,X,Y,W,H)
        ;Debug "Gadget: "+Str(\Gadget)
        
        If \Gadget = #Gad_RollInfo_Comment_Box
          Debug "Scaling comment box"
          Debug "FontID: "+Str(\FontID)
        EndIf
        
      Else
        X = \KeyPosX * ScaleX
        Y = \KeyPosY * ScaleY
        W = \KeySizeX * ScaleMin
        H = \KeySizeY * ScaleMin
        SetGadgetFont(\Gadget,FontID(\FontID))
        ResizeGadget(\Gadget,X,Y,W,H)

      EndIf 
      
      If \ColumnCount > 0 ;/ listicon
        For MyLoop = 0 To \ColumnCount
          ;Debug "Resizing Column: "+Str(MyLoop)+" from: "+Str(\ColumnSize[MyLoop])+" - To: "+Str(\ColumnSize[MyLoop]*ScaleX)
          
          SetGadgetItemAttribute(\Gadget,0,#PB_ListIcon_ColumnWidth,\ColumnSize[MyLoop] * ScaleX,MyLoop)
        Next
      EndIf
      
    EndWith
  Next
  
  Form_Update_Images()
  
EndProcedure
Procedure Window_Callback(WindowID, Message, wParam, lParam)
  Protected *SizeTracking.MINMAXINFO
  ; Here is the trick. The GETMINMAXINFO must be processed
  ; and filled with min/max values...
  ;
  If Message <> 32 And Message <> 132 And Message <> 160 And Message <> 512 And Message <> 78
    ;Debug "Callback triggered: "+Str(message)
  EndIf
  
  Select Message
    Case #WM_MOUSEWHEEL
      Debug "Mouse Wheel Event: "+Str(wParam)+" - "+Str(lParam)
    Case #WM_SIZE 
      Select wParam 
        Case #SIZE_MINIMIZED 
          HideWindow(#Window_Main,1)
          ;ShowWindow_(WindowID(#Window_Main),#SW_HIDE)
          AddSysTrayIcon(0, WindowID(#Window_Main), ImageID(#Image_AniCAMIcon))
          SysTrayIconToolTip(0, tTxt(#Str_TroikaSystems)+" - "+tTxt(#Str_AMS))
          System\WindowMinimized = 1
          If System\LiveMonitor = 1
            WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),tTxt(#Str_LivemonitoringforAMSexportison),3000)
          Else
            WindowShowBalloonTip(#Window_Main,0,tTxt(#Str_AMSmessage),tTxt(#Str_LivemonitoringforAMSexportsisoff),3000)
          EndIf
      EndSelect
      
    Case #WM_GETMINMAXINFO
      *SizeTracking.MINMAXINFO = lParam
      *SizeTracking\ptMinTrackSize\X = 1024
      *SizeTracking\ptMinTrackSize\Y = 700
      *SizeTracking\ptMaxTrackSize\X = GetSystemMetrics_(#SM_CXSCREEN)
      *SizeTracking\ptMaxTrackSize\Y = GetSystemMetrics_(#SM_CYSCREEN)
  EndSelect
  
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

Procedure.i Printer_ID_Number_Of_Copies()
  Protected *d.DEVMODE,   Full.devmode
  
  ;Print_PrintDlg(0)
  ;*d=Print_LoadDEVMODE("")
  Debug *d\dmCopies
  CopyMemory(*d,@Full,SizeOf(DEVMODE))
  
  ProcedureReturn  Full\dmCopies
  
EndProcedure

Procedure.s Export_Excel_CellFromRC(Column.i,Row.i)
  Protected Cell.s
  Cell = Chr(Column+96)+Str(Row)
;  Debug Cell
  ProcedureReturn Cell.s
EndProcedure

Procedure PDF_Header()
  If System\OEMLogo.s = ""
    pdf_ImageMem("Troika AMS.jpg",?Logo_Opaque,?Logo_Opaque_End-?Logo_Opaque,10,4,50,20)  ;/DNT
  Else
    pdf_Image("OEM\OEM Logo PDF.jpg",10,4,50,20)  ;/DNT
  EndIf
  
  Debug pdf_GetErrorMessage()
  pdf_Ln(20)
EndProcedure
Procedure PDF_Footer()
  If pdf_GetNumberingFooter() = #False 
    ProcedureReturn
  EndIf
  pdf_SetY(-15)
  pdf_SetFontSize(8)  ;/DNT
  pdf_Cell(0,7,Str(pdf_NumPageNum()),0,0,#PDF_ALIGN_CENTER)
  If pdf_GetNumbering() = #False 
    pdf_SetNumberingFooter(#False)
  EndIf
EndProcedure

Procedure WrapText(x,y,text.s,width,HeightStep,color, Crop.i = 0) 
  Protected Limit.i, Cut.i
  FrontColor(color)
  If TextWidth(text)<=width 
    DrawText(x,y,text) 
  Else 
    limit=0 : Repeat : limit+1 : Until TextWidth(Left(text,limit))>width : cut=limit 
    Repeat : cut-1 : Until Mid(text,cut,1)=" " Or Mid(text,cut,1)="-" Or cut=0 
    If cut=0 : cut=limit-1 : EndIf 
    DrawText(x,y,Left(text,cut))
    If Crop = 0
      WrapText(x,y+HeightStep,Right(text,Len(text)-cut),width,HeightStep,color) 
    EndIf
  EndIf 
EndProcedure

Procedure Export_RollReport_Print()
  Protected MyLoop.i, File.s, PageWidth.i, PageHeight.i, MinX.i, MaxX.i, MinY.i, MaxY.i, SizeX.f, SizeY.f
  Protected PageSizeX.i, PageSizeY.i, ScaleX.f, ScaleY.f, MinScale.f, PosX.f, PosY.f
  Protected GadSizeX.f, GadSizeY.f, Excluded.i, Edge_Left.i, Edge_Right.i
  Protected Text.s, Column.i, ColumnCount.i, SM.s, TmpTxt.s, Temp.i, Width.i, Colour.i, Pattern.s
  Protected NeedNewPage.i, OnNewPage.i, TemporaryImage.i, ColumnX.i, ColumnY.i, OnPage.i
  
  Dim ColumnWidths.i(16)
  
  ColumnCount = GetGadgetColumns(#Gad_Report_ReportList)
  
  OnNewPage = 1 : OnPage = 1
  
  If PrintRequester()
    If StartPrinting("AMS Output")
      ;/ Get the page size and setup the scale values / Load fonts
      PageSizeX = PrinterPageWidth(); * 0.9 ;/ Margins
      PageSizeY = PrinterPageHeight(); * 0.98 ;/ Margins
      ScaleX = PageSizeX / 724.0
      ScaleY = PageSizeY / (690.0);* 1.25)
      ;If ScaleY < 10 : ScaleY = 10.0 : EndIf
      MinScale = ScaleX : If ScaleY < ScaleX : MinScale = ScaleY : EndIf
      If PageSizeX > PagesizeY And ScaleY < 10 : ScaleY = 10.0 : EndIf ;/ Fix for portrait mode??
      Debug "PageSize X / Y: "+StrF(PageSizeX,1)+" / "+StrF(PageSizeY,1)
      Debug "Scale X / Y: "+StrF(ScaleX,1)+" / "+StrF(ScaleY,1)
      Debug "MinScale: "+StrF(MinScale,1)
      
      Init_Fonts_Print(MinScale)
      
      If StartDrawing(PrinterOutput())
        DrawingFont(FontID(#Font_Report_XS))
        For Myloop = 0 To CountGadgetItems(#Gad_Report_ReportList)
          For Column = 0 To ColumnCount - 1
            TmpTxt = GetGadgetItemText(#Gad_Report_ReportList,MyLoop,Column)
            If TextWidth(TmpTxt) > ColumnWidths(Column) : ColumnWidths(Column) = TextWidth(TmpTxt) : EndIf
          Next
        Next
        
        ;/ Set Final columns width to extend to page width (for the 'Comments' box) - Need to remove this if showing a flat report? 
        Width = 0
        For Column = 0 To ColumnCount - 2
          Width + ColumnWidths(Column)
        Next
        
        ColumnWidths(ColumnCount-1) = ((PageSizeX*0.8) - Width)
        PosX = PageSizeX * 0.025 : PosY = PageSizeY * 0.025

        For Myloop = 0 To CountGadgetItems(#Gad_Report_ReportList)
          
          If OnNewPage = 1
            ColumnY = PosY + (74*ScaleY)
            DrawingFont(FontID(#Font_Report_L_Bold))
            FrontColor(RGB(0,0,0))
            BackColor(RGB(255,255,255))
            
            OnNewPage = 0
            ;PosX = PageSizeX * 0.025 : PosY = PageSizeY * 0.025
            CopyImage(#Image_OEM_Logo,#Image_Temp)
            ResizeImage(#Image_Temp,ImageWidth(#Image_OEM_Logo) * Minscale,ImageHeight(#Image_OEM_Logo) * Minscale,#PB_Image_Raw)
            DrawImage(ImageID(#Image_Temp), PosX, PosY)

;            DrawImage(ImageID(#Image_OEM_Logo), PosX, PosY, ImageWidth(#Image_OEM_Logo) * Minscale,ImageHeight(#Image_OEM_Logo) * Minscale)
            RoundBox(PosX+(320 * ScaleX), PosY, 362*ScaleX, 64 * ScaleY, 60, 60, RGB(255,255,230))
            
            BackColor(RGB(255,255,230))
            TmpTxt = "AMS - " + tTxt(#Str_Roll)+tTxt(#Str_Overview)+tTxt(#Str_Report)+" - Page: "+Str(OnPage)
            DrawText(PosX+(324 * ScaleX), PosY+10, TmpTxt)
            DrawingFont(FontID(#Font_Report_XS))
            
            TmpTxt = tTxt(#Str_Filter)+": " + GetGadgetText(#Gad_Report_Preset_Combo)
            DrawText(PosX+(324 * ScaleX), PosY + (32 * ScaleY), TmpTxt)
            TmpTxt = tTxt(#Str_Sortedby)+": " + GetGadgetText(#Gad_Report_SortBy_Combo)+ " (" + GetGadgetText(#Gad_Report_SortDirection_Combo) + ")"
            DrawText(PosX+(324 * ScaleX), PosY + (42 * ScaleY), TmpTxt)
            TmpTxt = tTxt(#Str_Reportgenerationdate)+": " + UnitConversion_Date(Date())
            DrawText(PosX+(324 * ScaleX), PosY + (52 * ScaleY), TmpTxt)
          EndIf

          ColumnX = PosX
          For Column = 0 To ColumnCount - 1
            ;Width = GetGadgetItemAttribute(#Gad_Report_ReportList,MyLoop,#PB_ListIcon_ColumnWidth,Column) * ScaleX
            Width = (ColumnWidths(Column) * 1.12)+28
            TmpTxt = GetGadgetItemText(#Gad_Report_ReportList,MyLoop,Column)
            Colour = GetGadgetItemColor(#Gad_Report_ReportList,MyLoop,#PB_Gadget_BackColor ,Column)
            If Colour = -1 : Colour = RGB(255,255,255) : EndIf
            BackColor(Colour);
            Box(ColumnX,ColumnY,Width-10,(12 * ScaleY)-10,Colour)
            WrapText(ColumnX+14,ColumnY+16,TmpTxt.s,Width,0,0 , 1) 
            ;DrawText(ColumnX+14,ColumnY+16, TmpTxt)
            ColumnX + Width
          Next
 
          ColumnY + (12*ScaleY)
          
          ;/ check for page wrap to prevent header split
          If GetGadgetItemText(#Gad_Report_ReportList,MyLoop+1,0) = ""
            If ColumnY + (12*ScaleY*5) > PagesizeY
              ColumnY + (12*ScaleY*5)
            EndIf
          EndIf

          If ColumnY + (12*ScaleY*2) > PageSizeY
            OnNewPage = 1 : OnPage + 1
            NewPrinterPage()
          EndIf
        Next
        StopDrawing()
      EndIf
      StopPrinting()
    EndIf
  EndIf

EndProcedure

Procedure Export_Rollinfo_Print()
  Protected MyLoop.i, File.s, PageWidth.i, PageHeight.i, MinX.i, MaxX.i, MinY.i, MaxY.i, SizeX.f, SizeY.f, PageSizeX.i, PageSizeY.i, ScaleX.f, ScaleY.f, PosX.f, PosY.f
  Protected GadSizeX.f, GadSizeY.f, Excluded.i, LeftBorder.i, Column.i, OnLine.i, LineCount.i, FilePattern.s, TopBorder.i, Col.i, Justify.s
  Protected MinScale.f, GadSizeFX.f, GadSizeFY.f, JustifyOffsetX.i, Text.s, Frontcol.i, BackCol.i
  SetActiveGadget(-1) ;/ remove any gadget selection
  
  MinX = 9999 : MaxX = -9999
  MinY = 9999 : MaxY = -9999

  If PrintRequester()
    If StartPrinting("AMS Output")
      ;/ Get the page size and setup the scale values / Load fonts
      For MyLoop = #Gad_RollInfo_Start To #Gad_RollInfo_Finish
        If IsGadget(MyLoop)
          ForEach GadgetScale()
            If GadgetScale()\Gadget = MyLoop : Break : EndIf
          Next
          If GadgetScale()\KeyPosX < MinX : MinX = GadgetScale()\KeyPosX : EndIf
          If GadgetScale()\KeyPosX + GadgetScale()\KeySizeX > MaxX : MaxX = GadgetScale()\KeyPosX + GadgetScale()\KeySizeX: EndIf
          If GadgetScale()\KeyPosY < MinY : MinY = GadgetScale()\KeyPosY : EndIf
          If GadgetScale()\KeyPosY + GadgetScale()\KeySizeY > MaxY : MaxY = GadgetScale()\KeyPosY + GadgetScale()\KeySizeY: EndIf
        EndIf
      Next
      PageSizeX = PrinterPageWidth(); * 0.9 ;/ Margins
      PageSizeY = PrinterPageHeight(); * 0.98 ;/ Margins
      ScaleX = PageSizeX / 724.0
      ScaleY = PageSizeY / 840.0
      MinScale = ScaleX : If ScaleY < ScaleX : MinScale = ScaleY : EndIf
      If PageSizeX > PagesizeY And ScaleY < 10 : ScaleY = 10.0 : EndIf ;/ Fix for portrait mode?
      
      Init_Fonts_Print(MinScale)
      
      If StartDrawing(PrinterOutput())
        DrawingFont(FontID(#Font_Report_S))
        
        SizeX = MaxX - MinX
        SizeY = MaxY - MinY
        ;ScaleX = SizeX / PageSizeX
        ;ScaleY = SizeY / PageSizey
        LeftBorder = 32 * ScaleX
        TopBorder = 20 * ScaleY

        BackColor(RGB(0,0,0))
        CopyImage(#Image_OEM_Logo,#Image_Temp)
        ResizeImage(#Image_Temp,ImageWidth(#Image_OEM_Logo) * (Minscale*0.75),ImageHeight(#Image_OEM_Logo) * (Minscale*0.75),#PB_Image_Raw)
        DrawImage(ImageID(#Image_Temp), LeftBorder, TopBorder)

        DrawingMode(#PB_2DDrawing_Outlined)
        BackColor(RGB(255,255,255))
        RoundBox((2*ScaleX)+LeftBorder,(64*ScaleY)+TopBorder,PageSizeX-(60*ScaleX),210*ScaleY,40,40,RGB(0,0,0))

        For MyLoop = #Gad_RollInfo_Start To #Gad_RollInfo_Finish
          BackColor(RGB(255,255,255))
          FrontColor(RGB(0,0,0))
          If IsGadget(MyLoop)
            ;/ Exclude specific gadgets from being displayed on the report
            Excluded = 0
            If MyLoop = #Gad_RollInfo_Commit     : Excluded = 1 : EndIf
            If MyLoop = #Gad_RollInfo_Undo       : Excluded = 1 : EndIf
            If MyLoop = #Gad_RollInfo_Import_AMS : Excluded = 1 : EndIf
            If MyLoop = #Gad_RollInfo_Import_ACP : Excluded = 1 : EndIf
            If MyLoop = #Gad_RollInfo_Commit     : Excluded = 1 : EndIf
            If MyLoop = #Gad_RollInfo_Import_New : Excluded = 1 : EndIf
            
            If Excluded = 0
              ForEach GadgetScale()
                If GadgetScale()\Gadget = MyLoop : Break : EndIf
              Next
              
              If Myloop = #Gad_RollInfo_GeneralHistory_History_List
                pdfx = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + leftborder
                pdfy = (((GadgetScale()\KeyPosY-MinY)*ScaleY)+26+TopBorder) + (68*ScaleY)
                GadSizeY = (16*ScaleY)
                LineCount = CountGadgetItems(#Gad_RollInfo_GeneralHistory_History_List)
                If LineCount > 3 : LineCount = 3 : EndIf ;/ limit the amount of lines being displayed on the general history box
                
                SetGadgetState(#Gad_RollInfo_GeneralHistory_History_List,-1)
                
                For OnLine = -1 To Linecount
                  For Column = 0 To 2
                    GadSizeX = GadgetScale()\ColumnSize[Column] * ScaleX
                    If Online = -1 ;/ show header
                      DrawingMode(#PB_2DDrawing_Default)
                      FrontColor(RGB(220,220,220))
                      Box(pdfx,pdfy,GadSizeX,GadSizeY)
                      BackColor(RGB(220,220,220))
                    Else
                      BackColor(RGB(255,255,255))
                    EndIf

                    FrontColor(RGB(0,0,0))
                    DrawingMode(#PB_2DDrawing_Outlined)
                    Box(pdfx,pdfy,GadSizeX,GadSizeY)
                    FrontColor(RGB(0,0,0))
                    DrawText(pdfx+(2*ScaleX),pdfy+(2*ScaleY),GetGadgetItemText(Myloop,Online,Column))
                    pdfx + GadSizeX
                    ;pdf_Cell(GadgetScale()\ColumnSize[Column] * ScaleX ,4,GetGadgetItemText(Myloop,Online,Column),-15,0,#PDF_ALIGN_LEFT,1)
                  Next
                  pdfx = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + (leftborder-1)
                  pdfy + GadSizeY
                Next
              EndIf
              
              If Myloop = #Gad_RollInfo_Original_List
                SetGadgetState(#Gad_RollInfo_Original_List,-1)
                pdfx = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + leftborder
                pdfy = (((GadgetScale()\KeyPosY-MinY)*ScaleY)+26+TopBorder) + (64*ScaleY)
                GadSizeY = (20*ScaleY)
                
                For OnLine = 0 To 1
                  For Column = 0 To 11
                    GadSizeX = GadgetScale()\ColumnSize[Column] * ScaleX
                    Text = GetGadgetItemText(Myloop,Online,Column)
                    JustifyOffsetX = 2 * ScaleX
                    If Column > 1 
                      JustifyOffsetX = (GadSizeX/2) - (TextWidth(Text) / 2.0)
                    EndIf
                    ;/ Set foreground / Background colouring
                    FrontCol.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_FrontColor,Column)
                    If FrontCol = -1 : FrontCol = 0 : EndIf
                    FrontColor(FrontCol)
                    BackCol.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_BackColor,Column)
                    If BackCol = -1 : BackCol = RGB(255,255,255) : EndIf

                    FrontColor(Backcol)
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(pdfx,pdfy,GadSizeX,GadSizeY)
                    FrontColor(0)
                    BackColor(0)
                    DrawingMode(#PB_2DDrawing_Outlined)
                    Box(pdfx,pdfy,GadSizeX,GadSizeY)
                    DrawingMode(#PB_2DDrawing_Default)
                    BackColor(BackCol)
                    FrontColor(FrontCol)
                    DrawText(pdfx+JustifyOffsetX,pdfy+(5*ScaleY),GetGadgetItemText(Myloop,Online,Column))
                    pdfx + GadSizeX
                  Next
                  pdfx = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + (leftborder-1)
                  pdfy + GadsizeY
                Next
              EndIf
              ;               
              LineCount = CountGadgetItems(#Gad_RollInfo_History_List) - 1
              ;
              If LineCount > 7 : LineCount = 7 : EndIf ;/ limit the amount of lines being displayed on the general history box
              ;
              If Myloop = #Gad_RollInfo_History_List
                SetGadgetState(#Gad_RollInfo_History_List,-1)
                pdfx = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + leftborder
                pdfy = (((GadgetScale()\KeyPosY-MinY)*ScaleY)+26+TopBorder) + (64*ScaleY)
                GadSizeY = (20*ScaleY)
                ;
                For OnLine = 0 To LineCount
                  For Column = 0 To 11
                    GadSizeX = GadgetScale()\ColumnSize[Column] * ScaleX
                    Text = GetGadgetItemText(Myloop,Online,Column)
                    
                    JustifyOffsetX = 2 * ScaleX
                    If Column > 1 
                      JustifyOffsetX = (GadSizeX/2) - (TextWidth(Text) / 2.0)
                    EndIf
                    ;/ Set foreground / Background colouring
                    FrontCol.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_FrontColor,Column)
                    If FrontCol = -1 : FrontCol = 0 : EndIf
                    FrontColor(FrontCol)
                    BackCol.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_BackColor,Column)
                    If BackCol = -1 : BackCol = RGB(255,255,255) : EndIf

                    FrontColor(Backcol)
                    DrawingMode(#PB_2DDrawing_Default)
                    Box(pdfx,pdfy,GadSizeX,GadSizeY)
                    FrontColor(0)
                    BackColor(0)
                    DrawingMode(#PB_2DDrawing_Outlined)
                    Box(pdfx,pdfy,GadSizeX,GadSizeY)
                    DrawingMode(#PB_2DDrawing_Default)
                    BackColor(BackCol)
                    FrontColor(FrontCol)
                    DrawText(pdfx+JustifyOffsetX,pdfy+(5*ScaleY),GetGadgetItemText(Myloop,Online,Column))
                    pdfx + GadSizeX

                  Next
                  pdfx = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + (leftborder-1)
                  pdfy + GadsizeY
                Next
              EndIf                 
                 
               PosX = ((GadgetScale()\KeyPosX-MinX)*ScaleX) + leftborder
               PosY = (((GadgetScale()\KeyPosY-MinY)*ScaleY)+26+TopBorder) + (68*ScaleY)
               GadSizeX = GadgetScale()\KeySizeX * ScaleX
               GadSizeY = GadgetScale()\KeySizeY * ScaleY
               GadSizeFX = GadgetScale()\KeySizeX * MinScale
               GadSizeFY = GadgetScale()\KeySizeY * MinScale
               
;               Debug "PosX(Y): "+Str(PosX)+", "+Str(PosY)
               If GadgetType(GadgetScale()\Gadget) <> #PB_GadgetType_Text And GadgetType(GadgetScale()\Gadget) <> #PB_GadgetType_Image
                 If GetGadgetText(MyLoop) <> ""
                   FrontColor(RGB(220,220,220))
                   DrawingMode(#PB_2DDrawing_Default)
                   RoundBox(PosX-(3*ScaleX),PosY-(4*ScaleY),GadSizeX,GadSizeY,40,40)
                   
                   FrontColor(RGB(0,0,0))
                   DrawingMode(#PB_2DDrawing_Outlined)
                   RoundBox(PosX-(3*ScaleX),PosY-(4*ScaleY),GadSizeX,GadSizeY,40,40)
                   
                   BackColor(RGB(255,255,255))
                   FrontColor(RGB(0,0,0))
                 EndIf
               EndIf
              
               If GadgetType(GadgetScale()\Gadget) = #PB_GadgetType_Image
                 DrawingMode(#PB_2DDrawing_Default)
                 FrontColor(0)
                 BackColor(RGB(255,255,255))
                Select GadgetScale()\Gadget
                  Case #Gad_RollInfo_Image_Reference
                    If System\Reference_Image_Length > 0
                      DrawImage(ImageID(#Image_2d_Image_Reference),PosX,PosY,GadSizeFX,GadSizeFY)
                    EndIf
                    
                  Case #Gad_RollInfo_Image_Latest
                    If System\Current_Image_Length > 0
                      DrawImage(ImageID(#Image_2d_Image_Current),PosX,PosY,GadSizeFX,GadSizeFY)
                    EndIf
                    
                  Case #Gad_RollInfo_Wall_Image
                    DrawImage(ImageID(#Image_RollInfo_Wall_Opaque),PosX,PosY,GadSizeFX,GadSizeFY)
                    
                  Case #Gad_RollInfo_Opening_Image
                    DrawImage(ImageID(#Image_RollInfo_Opening_Opaque),PosX,PosY,GadSizeFX,GadSizeFY)
                    
                  Case #Gad_RollInfo_Screen_Image
                    DrawImage(ImageID(#Image_RollInfo_Screen_Opaque),PosX,PosY,GadSizeFX,GadSizeFY)
                    
                  Case #Gad_RollInfo_AniCAM_Image
                    DrawImage(ImageID(#Image_AniCAM),PosX,PosY,GadSizeFX,GadSizeFY)
                    
                  Case #Gad_RollInfo_Roll_Image
                    DrawImage(ImageID(#Image_RollInfo_Roll_Opaque),PosX,PosY+(6*ScaleY),GadSizeX*0.98,GadSizeFY)
                    
                  Case #Gad_RollInfo_Roll_Pins
                    DrawImage(ImageID(#Image_RollInfo_Roll_Pins_Opaque),PosX,PosY-(9*ScaleY),GadSizeX*0.98,GadSizeFY*2)
                EndSelect
                
              EndIf
              
              If GetGadgetText(MyLoop) <> "" 
                Select MyLoop
                  Case #Gad_Rollinfo_Readings_Text ;/ increase font size on readings text only
                    DrawingFont(FontID(#Font_Report_M))
                    DrawText(PosX,PosY,GetGadgetText(MyLoop))
                    DrawingFont(FontID(#Font_Report_S))
                  Default
                    If GadgetType(GadgetScale()\Gadget) = #PB_GadgetType_Text
                      FrontColor(RGB(0,0,0))
                      BackColor(RGB(255,255,255))
                      WrapText(PosX,PosY,GetGadgetText(MyLoop),GadSizeX,Scaley*12,0) 
                    Else
                      BackColor(RGB(220,220,220))
                      FrontColor(RGB(0,0,0))
                      WrapText(PosX,PosY,GetGadgetText(MyLoop),GadSizeX,Scaley*12,0) 
                    EndIf

                EndSelect
                
              EndIf 
            EndIf
            
          EndIf
        Next
        
        StopDrawing()
      EndIf
      StopPrinting()
    EndIf
  EndIf
  
EndProcedure

Procedure.i Export_RollReport_PDF()
  Protected MyLoop.i, File.s, PageWidth.i, PageHeight.i, MinX.i, MaxX.i, MinY.i, MaxY.i, SizeX.f, SizeY.f, PageSizeX.i, PageSizeY.i, ScaleX.f, ScaleY.f, PosX.f, PosY.f
  Protected GadSizeX.f, GadSizeY.f, Excluded.i, Edge_Left.i, Edge_Right.i, Text.s, Column.i, ColumnCount.i, SM.s, TmpTxt.s, Temp.i, Width.i, Colour.i, Pattern.s, Justify.s
  
  ColumnCount = GetGadgetColumns(#Gad_Report_ReportList)
  
  Pattern.s = "*.pdf|*.pdf" ;/DNT
  
  File.s = SaveFileRequester(tTxt(#Str_Enterfilename),"",Pattern,0)
  
  If File = "" : ProcedureReturn : EndIf
  If FileSize(File) > 0 ;/ file exists, prompt to overwrite)
    If MessageRequester(tTxt(#Str_Message),tTxt(#Str_Fileexists)+", "+tTxt(#Str_overwrite)+"?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
      ProcedureReturn 
    EndIf
  EndIf
  
  If UCase(Right(File,4)) <> ".PDF" : File + ".pdf" : EndIf ;/DNT
  
  If CreateFile(1,File)
    CloseFile(1)
  Else
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_Cannotwritetofile)+", "+tTxt(#Str_filealreadyopenelsewhere)+"?",#PB_MessageRequester_Ok)
    ProcedureReturn 
  EndIf
  
  pdf_Create()
  pdf_SetDisplayMode(#PDF_ZOOM_REAL,#PDF_LAYOUT_SINGLE)
  pdf_SetProcHeader(@PDF_Header())
  pdf_SetProcFooter(@PDF_Footer())
  pdf_AddPage("P",#PDF_PAGE_FORMAT_A4)
  pdf_StartPageNums()
  Debug "**** System Font: "+System\Font_Name
  pdf_SetFont(System\Font_Name,"",24) ;/DNT
  
  TmpTxt = "AMS - " ;/DNT
  TmpTxt + " "+tTxt(#Str_Roll)+tTxt(#Str_Overview)+tTxt(#Str_Report)
  pdf_Text(64,18,TmpTxt)
  
  pdf_SetFontSize(8)  ;/DNT
  
  pdf_SetTextColor(255);
  pdf_SetDrawColor(240,240,240);
  pdf_SetLineWidth(0.05);
  
  PageSizeX = pdf_GetW() * 0.9
  PageSizeY = pdf_GetH() - 64;/ remove header & footer space
  
  Debug "Page Size: "+Str(PageSizeX)+", "+Str(PageSizeY)
  
  pdf_SetFillColor(255,255,230)
  pdf_RoundRect(10,26,PageSizeX-8,20,1,#PDF_STYLE_DRAWANDFILL)
  pdf_Ln(22)
  ;  pdf_SetFont("Arial","B",8)
  pdf_SetTextColor(20)
  TmpTxt = tTxt(#Str_Filter)+":"+" "
  TmpTxt + " "
  TmpTxt + GetGadgetText(#Gad_Report_Preset_Combo)
  pdf_Text(11,30,TmpTxt)
  
  TmpTxt = tTxt(#Str_Sortedby)+":"
  TmpTxt + " "
  TmpTxt + GetGadgetText(#Gad_Report_SortBy_Combo)
  TmpTxt + " "+"("
  TmpTxt + GetGadgetText(#Gad_Report_SortDirection_Combo)
  TmpTxt + ")"
  pdf_Text(11,36,TmpTxt)
  
  TmpTxt = tTxt(#Str_Reportgenerationdate)+":"
  TmpTxt + " "
  TmpTxt + UnitConversion_Date(Date())

  pdf_Text(11,42,TmpTxt)
  
  pdf_SetFillColor(240,240,240)
  pdf_SetFontSize(7)  ;/DNT
  ScaleX = GadgetWidth(#Gad_Report_ReportList) / PageSizeX

  ;/ Header  
  For Myloop = 0 To CountGadgetItems(#Gad_Report_ReportList)
    Text = ""
    For Column = 0 To ColumnCount - 1
      Width = GetGadgetItemAttribute(#Gad_Report_ReportList,MyLoop,#PB_ListIcon_ColumnWidth,Column) / ScaleX
      TmpTxt = GetGadgetItemText(#Gad_Report_ReportList,MyLoop,Column)
      Colour = GetGadgetItemColor(#Gad_Report_ReportList,MyLoop,#PB_Gadget_BackColor ,Column)
      pdf_SetFillColor(Red(Colour),Green(Colour),Blue(Colour));
      
 ;     Colour = GetGadgetItemColor(#Gad_Report_ReportList,MyLoop,#PB_Gadget_FrontColor ,Column)
      pdf_SetTextColor(Red(0),Green(0),Blue(0));
      Justify.s = #PDF_ALIGN_LEFT
      If Column > 1 And Column < ColumnCount - 1
        Justify = #PDF_ALIGN_CENTER
      EndIf
      
      pdf_Cell(Width,6,TmpTxt,1,0,Justify,1)
    Next
    pdf_Ln()
  Next
  
  pdf_Ln()
  
  pdf_StopPageNums()
  pdf_Save(File)
;  pdf_End()
  RunProgram(File)
  
EndProcedure

Procedure.i Export_Rollinfo_PDF()
  Protected MyLoop.i, File.s, PageWidth.i, PageHeight.i, MinX.i, MaxX.i, MinY.i, MaxY.i, SizeX.f, SizeY.f, PageSizeX.i, PageSizeY.i, ScaleX.f, ScaleY.f, PosX.f, PosY.f
  Protected GadSizeX.f, GadSizeY.f, Excluded.i, LeftBorder.i, Column.i, OnLine.i, LineCount.i, FilePattern.s, TopBorder.i, Col.i, Justify.s
  
  SetActiveGadget(-1) ;/ remove any gadget selection
  
  FilePattern = "*.pdf|*.pdf" ;/DNT
  File.s = SaveFileRequester(tTxt(#Str_Enterfilename),"",FilePattern,0)
  
  If File = "" : ProcedureReturn : EndIf
  If FileSize(File) > 0 ;/ file exists, prompt to overwrite)
    If MessageRequester(tTxt(#Str_Message),tTxt(#Str_Fileexists)+", "+tTxt(#Str_overwrite)+"?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
      ProcedureReturn 
    EndIf
  EndIf
  
  If UCase(Right(File,4)) <> ".PDF" : File + ".pdf" : EndIf ;/DNT
  
  If CreateFile(1,File)
    CloseFile(1)
  Else
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_Cannotwritetofile)+", "+tTxt(#Str_filealreadyopenelsewhere)+"?",#PB_MessageRequester_Ok)
    ProcedureReturn 
  EndIf
  
  MinX = 9999 : MaxX = -9999
  MinY = 9999 : MaxY = -9999

  For MyLoop = #Gad_RollInfo_Start To #Gad_RollInfo_Finish
    If IsGadget(MyLoop)
      ForEach GadgetScale()
        If GadgetScale()\Gadget = MyLoop : Break : EndIf
      Next
      If GadgetScale()\KeyPosX < MinX : MinX = GadgetScale()\KeyPosX : EndIf
      If GadgetScale()\KeyPosX + GadgetScale()\KeySizeX > MaxX : MaxX = GadgetScale()\KeyPosX + GadgetScale()\KeySizeX: EndIf
      If GadgetScale()\KeyPosY < MinY : MinY = GadgetScale()\KeyPosY : EndIf
      If GadgetScale()\KeyPosY + GadgetScale()\KeySizeY > MaxY : MaxY = GadgetScale()\KeyPosY + GadgetScale()\KeySizeY: EndIf
    EndIf
  Next

  pdf_Create()
  pdf_SetDisplayMode(#PDF_ZOOM_REAL,#PDF_LAYOUT_SINGLE)
  pdf_SetProcHeader(@PDF_Header())
  pdf_SetProcFooter(@PDF_Footer())
  pdf_AddPage("P",#PDF_PAGE_FORMAT_A4)
  pdf_StartPageNums()
  
  Debug "**** System Font: "+System\Font_Name
  pdf_SetFont(System\Font_Name,"",8)  ;/DNT
  
  PageSizeX = pdf_GetW() - 4
  PageSizeY = pdf_GetH() - 96 ;/ remove header
  Debug "Page Size: "+Str(PageSizeX)+", "+Str(PageSizeY)
  
  SizeX = MaxX - MinX
  SizeY = MaxY - MinY
  ScaleX = SizeX / PageSizeX
  ScaleY = SizeY / PageSizey
  LeftBorder = 8
  TopBorder = 10
  Debug "Scale XY: "+StrF(ScaleX,1)+", "+StrF(ScaleY,1)
  Debug "Min XY: "+Str(MinX)+", "+Str(MinY)
  Debug "Max XY: "+Str(MaxX)+", "+Str(MaxY)
  
  pdf_SetFillColor(255,255,255)
  pdf_RoundRect(2+LeftBorder,20+TopBorder,pdf_GetW()-24-LeftBorder,62,2,#PDF_STYLE_DRAWANDFILL)
  
  pdf_SetFillColor(240,240,240)

  For MyLoop = #Gad_RollInfo_Start To #Gad_RollInfo_Finish
    If IsGadget(MyLoop)
      ;/ Exclude specific gadgets from being displayed on the report
      Excluded = 0
      If MyLoop = #Gad_RollInfo_Commit : Excluded = 1 : EndIf
      If MyLoop = #Gad_RollInfo_Undo : Excluded = 1 : EndIf
      If MyLoop = #Gad_RollInfo_Import_AMS : Excluded = 1 : EndIf
      If MyLoop = #Gad_RollInfo_Import_ACP : Excluded = 1 : EndIf
      If MyLoop = #Gad_RollInfo_Commit : Excluded = 1 : EndIf
      If MyLoop = #Gad_RollInfo_Import_New : Excluded = 1 : EndIf
      
      If Excluded = 0
        ForEach GadgetScale()
          If GadgetScale()\Gadget = MyLoop : Break : EndIf
        Next
        
        If Myloop = #Gad_RollInfo_GeneralHistory_History_List
          
          pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-1)
          pdfy = ((GadgetScale()\KeyPosY-MinY)/ScaleY)+23+TopBorder
          LineCount = CountGadgetItems(#Gad_RollInfo_GeneralHistory_History_List)
          If LineCount > 3 : LineCount = 3 : EndIf ;/ limit the amount of lines being displayed on the general history box
          SetGadgetState(#Gad_RollInfo_GeneralHistory_History_List,-1)
          For OnLine = -1 To Linecount
            For Column = 0 To 2
              pdf_Cell(GadgetScale()\ColumnSize[Column] / ScaleX ,4,GetGadgetItemText(Myloop,Online,Column),-15,0,#PDF_ALIGN_LEFT,1)
            Next
            pdf_Ln() : pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-1)
          Next
        EndIf
        
        If Myloop = #Gad_RollInfo_Original_List
          SetGadgetState(#Gad_RollInfo_Original_List,-1)

          pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-1)
          pdfy = ((GadgetScale()\KeyPosY-MinY)/ScaleY)+24+TopBorder
          For OnLine = 0 To 1
            For Column = 0 To 11
              Debug "GadgetScale "+Str(GadgetScale()\ColumnSize[Column])
              
              Justify = #PDF_ALIGN_LEFT
              If Column > 1 
                Justify = #PDF_ALIGN_CENTER
              EndIf
              
              ;/ Set foreground / Background colouring
              Col.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_FrontColor,Column)
              If Col = -1 : Col = 0 : EndIf
              pdf_SetTextColor(Red(Col), Green(Col), Blue(Col))
              
              Col.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_BackColor,Column)
              If Col = -1 : Col = RGB(255,255,255) : EndIf
              pdf_SetFillColor(Red(Col), Green(Col), Blue(Col))
              
              pdf_Cell(GadgetScale()\ColumnSize[Column] / ScaleX ,6,GetGadgetItemText(Myloop,Online,Column),-15,0,Justify,1)
            Next
            pdf_Ln() : pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-1)
          Next
        EndIf
        
        If Myloop = #Gad_RollInfo_History_List
          SetGadgetState(#Gad_RollInfo_History_List,-1)
          
          pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-1)
          pdfy = ((GadgetScale()\KeyPosY-MinY)/ScaleY)+24+TopBorder
          LineCount = CountGadgetItems(#Gad_RollInfo_History_List) - 1
          If LineCount > 15 : LineCount = 15 : EndIf
          For OnLine = 0 To Linecount
            For Column = 0 To 11
              
              Justify = #PDF_ALIGN_LEFT
              If Column > 1 
                Justify = #PDF_ALIGN_CENTER
              EndIf

              Col.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_FrontColor,Column)
              If Col = -1 : Col = 0 : EndIf
              
              pdf_SetTextColor(Red(Col), Green(Col), Blue(Col))
              
              Col.i = GetGadgetItemColor(Myloop,Online,#PB_Gadget_BackColor,Column)
              If Col = -1 : Col = RGB(255,255,255) : EndIf
              
              pdf_SetFillColor(Red(Col), Green(Col), Blue(Col))
              pdf_Cell(GadgetScale()\ColumnSize[Column] / ScaleX ,6,GetGadgetItemText(Myloop,Online,Column),-15,0,Justify,1)
            Next
            pdf_Ln() : pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-1)
          Next
        EndIf

        PosX = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + leftborder
        PosY = ((GadgetScale()\KeyPosY-MinY)/ScaleY)+26+TopBorder
        GadSizeX = GadgetScale()\KeySizeX / ScaleX
        GadSizeY = GadgetScale()\KeySizeY / ScaleY
        
        Debug "PosX(Y): "+Str(PosX)+", "+Str(PosY)
        If GadgetType(GadgetScale()\Gadget) <> #PB_GadgetType_Text And GadgetType(GadgetScale()\Gadget) <> #PB_GadgetType_Image
          If GetGadgetText(MyLoop) <> "" : pdf_RoundRect(PosX-2,PosY-3,GadSizeX,GadSizeY,1,#PDF_STYLE_DRAWANDFILL) : EndIf
        EndIf
        
        If GadgetType(GadgetScale()\Gadget) = #PB_GadgetType_Image
          Select GadgetScale()\Gadget
            Case #Gad_RollInfo_Image_Reference
              If System\Reference_Image_Length > 0
                pdf_ImageMem("Scan1",System\ReferenceImage,System\Reference_Image_Length,PosX-2,PosY-3,GadSizeX,GadSizeY)   ;/DNT 
              EndIf
              
            Case #Gad_RollInfo_Image_Latest
              If System\Current_Image_Length > 0
                pdf_ImageMem("Scan2",System\CurrentImage,System\Current_Image_Length,PosX-2,PosY-3,GadSizeX,GadSizeY);/DNT
              EndIf

            Case #Gad_RollInfo_Wall_Image
              pdf_ImageMem("Wall",?Roll_Wall_Opaque,?Roll_Wall_Opaque_End - ?Roll_Wall_Opaque,PosX-2,PosY-3,GadSizeX,GadSizeY);/DNT
              
            Case #Gad_RollInfo_Opening_Image
              pdf_ImageMem("Opening",?Roll_Opening_Opaque,?Roll_Opening_Opaque_End - ?Roll_Opening_Opaque,PosX-2,PosY-3,GadSizeX,GadSizeY);/DNT
              
            Case #Gad_RollInfo_Screen_Image
              pdf_ImageMem("Screen",?Roll_Screen_Opaque,?Roll_Screen_Opaque_End - ?Roll_Screen_Opaque,PosX-2,PosY-3,GadSizeX,GadSizeY);/DNT

            Case #Gad_RollInfo_AniCAM_Image
              pdf_ImageMem("AniCAM",?AniCAM_Opaque,?AniCAM_Opaque_End - ?AniCAM_Opaque,PosX-2,PosY-3,GadSizeX,GadSizeY);/DNT
              
            Case #Gad_RollInfo_Roll_Image
              pdf_ImageMem("Roll",?Roll_Opaque,?Roll_Opaque_End - ?Roll_Opaque,PosX-2,PosY-3.5,GadSizeX,GadSizeY+1);/DNT
              
            Case #Gad_RollInfo_Roll_Pins
              pdf_ImageMem("RollPins",?Roll_Pins_Opaque,?Roll_Pins_Opaque_End - ?Roll_Pins_Opaque,PosX-2,PosY-3.5,GadSizeX,GadSizeY+1) ;/DNT
              
          EndSelect
          
        EndIf
        
        If GetGadgetText(MyLoop) <> "" 
          Select MyLoop
            Case #Gad_Rollinfo_Readings_Text ;/ increase font size on readings text only
              pdf_SetFontSize(14) ;/DNT
              pdf_Text(PosX-1,PosY,GetGadgetText(MyLoop))
              pdf_SetFontSize(8)  ;/DNT
            Case #Gad_RollInfo_Comment_Box
              ;2+LeftBorder,20+TopBorder,pdf_GetW()-24-LeftBorder,62,2,#PDF_STYLE_DRAWANDFILL)
              pdfx = ((GadgetScale()\KeyPosX-MinX)/ScaleX) + (leftborder-2)
              pdfy = ((GadgetScale()\KeyPosY-MinY)/ScaleY)+24+TopBorder
              pdf_MultiCell(GadgetScale()\KeySizeX / ScaleX,(GadgetScale()\KeySizeY / ScaleY)/4.0,GetGadgetText(MyLoop),0,#PDF_ALIGN_Justified,0,0,3)
            Default
              pdf_Text(PosX-1,PosY,GetGadgetText(MyLoop))
          EndSelect
          
        EndIf 
      EndIf
      
    EndIf
  Next
  
  pdf_StopPageNums()
  pdf_Save(File)
  pdf_End()
  RunProgram(File)

EndProcedure

Procedure.i Export_Excel(View.i) ;/ Report = 0, Anilox = 1
  Protected MyLoop.i, File.s, Text.s, Column.i, ColumnCount.i, SM.s, TmpTxt.s, Temp.i, Online.i
  Protected ExcelObject.COMateObject , WorkBook.i, CellColour.i, Range.s, Tmp.s
  Protected CommentsLine.i, GeneralHistLine.i
  ExcelObject = COMate_CreateObject("Excel.Application")  ;/DNT
  If ExcelObject
    If ExcelObject\SetProperty("Visible = #True") = #S_OK ;/DNT
      ;XLSFunc_ExcelVisible(ExcelObject,#False); Nothing to see Excel
      WorkBook = ExcelObject\GetObjectProperty("Workbooks\Add") ;/DNT
      If WorkBook
        If View = 0 ;/ Roll report
          XLSFunc_WriteCellS(ExcelObject, 1, 1,"AMS") ;/DNT
          ColumnCount = GetGadgetColumns(#Gad_Report_ReportList)
          XLSFunc_WriteCellS(ExcelObject, 1, 1,"AMS: Export") ;/DNT
          XLSFunc_AddComment(ExcelObject, "A1","Exported from Troika Systems AMS Software - "+Program_Version) ;/DNT
          XLSFunc_WriteCellS(ExcelObject, 1, 2,UnitConversion_Date(Date()))
          XLSFunc_RenameActiveSheet(ExcelObject,"AMS Export") ;/DNT
          
          Online = 3
          For Myloop = 0 To CountGadgetItems(#Gad_Report_ReportList)
            CellColour = GetGadgetItemColor(#Gad_Report_ReportList,Myloop,#PB_Gadget_BackColor,0)
            
            For Column = 0 To ColumnCount
              XLSFunc_WriteCellS(ExcelObject, Online, Column+1,GetGadgetItemText(#Gad_Report_ReportList,MyLoop,Column))
            Next
            Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(ColumnCount,OnLine)
            XLSFunc_SetColor(ExcelObject, Range ,Red(CellColour),Green(CellColour),Blue(CellColour))
            XLSFunc_SetBorders(ExcelObject, Range,60,#xlContinuous,#xlThin,0)
            Online + 1
          Next
          XLSFunc_SetRowAutofit(ExcelObject,"A:I")  ;/DNT
          XLSFunc_SetFontAlignment(ExcelObject, "A:I",#xlHAlignLeft,#xlHAlignCenter) ;/DNT
          ;          xlWorkSheet.Shapes.AddPicture("C:\\csharp-xl-picture.JPG", Microsoft.Office.Core.MsoTriState.msoFalse, Microsoft.Office.Core.MsoTriState.msoCTrue, 50, 50, 300, 45); 
          ;/ **********************************************************************************
        Else ;/ writing RollInfo view
  
          XLSFunc_WriteCellS(ExcelObject, 1, 1,"AMS") ;/DNT
          ColumnCount = GetGadgetColumns(#Gad_Report_ReportList)
          XLSFunc_WriteCellS(ExcelObject, 1, 1,tTxt(#Str_AMS)+":"+" Export")
          Tmp = "A1" ;/DNT
          XLSFunc_AddComment(ExcelObject,Tmp,tTxt(#Str_ExportedfromTroikaSystemsAMSSoftware)+" - "+Program_Version)
          XLSFunc_WriteCellS(ExcelObject, 1, 2,UnitConversion_Date(Date()))
          XLSFunc_RenameActiveSheet(ExcelObject,tTxt(#Str_AMSExport))
          
          OnLine = 3
          ;/ Write Master Roll Data
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_RollID)) : XLSFunc_WriteCellS(ExcelObject,Online,2,RollInfo\RollID) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Manufacturer)) : XLSFunc_WriteCellS(ExcelObject,Online,2,Get_Manufacturer_Text()) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Datemade)) : XLSFunc_WriteCellS(ExcelObject,Online,2,UnitConversion_Date(RollInfo\DateMade)) : OnLine + 1
          
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Group)) : XLSFunc_WriteCellS(ExcelObject,Online,2,GetGadgetText(#Gad_Rollinfo_Group_Combo)) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Suitability)) : XLSFunc_WriteCellS(ExcelObject,Online,2,Get_Suitability_Text()) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Screencount)) : XLSFunc_WriteCellS(ExcelObject,Online,2,RollInfo\Screen) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Wallwidth)) : XLSFunc_WriteCellS(ExcelObject,Online,2,RollInfo\WallWidth) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Cellopening)) : XLSFunc_WriteCellS(ExcelObject,Online,2,RollInfo\CellOpening) : OnLine + 1
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Rollwidth)) : XLSFunc_WriteCellS(ExcelObject,Online,2,RollInfo\RollWidth); : OnLine + 1
          
          Range.s = Export_Excel_CellFromRC(1,3)+":"+Export_Excel_CellFromRC(1,OnLine)
          XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
          XLSFunc_SetColor(ExcelObject, Range ,240,240,190)
          
          Range.s = Export_Excel_CellFromRC(2,3)+":"+Export_Excel_CellFromRC(2,OnLine)
          XLSFunc_SetColor(ExcelObject, Range ,250,250,200)
           
          Range.s = Export_Excel_CellFromRC(1,3)+":"+Export_Excel_CellFromRC(2,OnLine)
          XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)
           
          Online + 2
          
          ;/ Write Comment
          CommentsLine = Online
          
          ;/ Write General history (Deffered to end due to line size_
          Online + 2
          GeneralHistLine = Online
          Online + 3 + CountGadgetItems(#Gad_RollInfo_GeneralHistory_History_List)
          
          ;/ Write Reference Data
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Referencereading)+":")
          Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(1,OnLine)
          XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
          Online + 1
          
          For Myloop = 0 To 1
            For Column = 0 To 10
              XLSFunc_WriteCellS(ExcelObject,Online,Column+1,GetGadgetItemText(#Gad_RollInfo_Original_List,Myloop,Column))
            Next
            If MyLoop = -1
              Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(11,OnLine)
              XLSFunc_SetColor(ExcelObject, Range ,240,245,190)
              XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)
              XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
            Else
              Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(11,OnLine)
              XLSFunc_SetColor(ExcelObject, Range ,250,250,200)
              XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0) 
            EndIf
            
            
            Online + 1
          Next
    
          ;/ Write Historical Data
          Online + 1
          
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Historicalreadings)+":")
          Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(1,OnLine)
          XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
          Online + 1
          
          For Myloop = -1 To CountGadgetItems(#Gad_RollInfo_History_List)-1
            For Column = 0 To 10
              XLSFunc_WriteCellS(ExcelObject,Online,Column+1,GetGadgetItemText(#Gad_RollInfo_History_List,Myloop,Column))
            Next
            If MyLoop = -1
              Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(11,OnLine)
              XLSFunc_SetColor(ExcelObject, Range ,240,240,190)
              XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)
              XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
            Else
              Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(11,OnLine)
              XLSFunc_SetColor(ExcelObject, Range ,250,250,200)
              XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)            
            EndIf
            
            Online + 1
          Next
          
          ;/ Tidy up
          XLSFunc_SetRowAutofit(ExcelObject,"A"+":"+"I")
          XLSFunc_SetFontAlignment(ExcelObject, "A"+":"+"I",#xlHAlignLeft,#xlHAlignCenter)

          XLSFunc_WriteCellS(ExcelObject,CommentsLine,1,tTxt(#Str_Comments))
          XLSFunc_WriteCellS(ExcelObject,CommentsLine,2,GetGadgetText(#Gad_RollInfo_Comment_Box))
          
          Range.s = Export_Excel_CellFromRC(1,CommentsLine)+":"+Export_Excel_CellFromRC(1,CommentsLine)
          XLSFunc_SetColor(ExcelObject, Range ,240,240,190)
          XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)
          XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
          
          Range.s = Export_Excel_CellFromRC(1,CommentsLine)+":"+Export_Excel_CellFromRC(16,CommentsLine)
          XLSFunc_SetBorders(ExcelObject, Range,60,#xlContinuous,#xlThin,0)
          XLSFunc_SetColor(ExcelObject, Range ,250,250,200)
          
          OnLine + 1
          
          
          Online = GeneralHistLine
          
          XLSFunc_WriteCellS(ExcelObject,Online,1,tTxt(#Str_Generalhistory)+":")
          Range.s = Export_Excel_CellFromRC(1,OnLine)+":"+Export_Excel_CellFromRC(1,OnLine)
          XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
          Online + 1
          
          For MyLoop = -1 To CountGadgetItems(#Gad_RollInfo_GeneralHistory_History_List) - 1
            For Column = 0 To 2
              XLSFunc_WriteCellS(ExcelObject,Online,Column+1,GetGadgetItemText(#Gad_RollInfo_GeneralHistory_History_List,MyLoop,Column))
            Next
            If Myloop = -1 ;/ header line
              Range.s = Export_Excel_CellFromRC(1,Online)+":"+Export_Excel_CellFromRC(2,Online)
              XLSFunc_SetColor(ExcelObject, Range ,240,240,190)
              XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)
              XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)
              
              Range.s = Export_Excel_CellFromRC(3,Online)+":"+Export_Excel_CellFromRC(16,Online)
              XLSFunc_SetColor(ExcelObject, Range ,240,240,190)
              XLSFunc_SetBorders(ExcelObject, Range,60,#xlContinuous,#xlThin,0)
              XLSFunc_SetFontStyle(ExcelObject, Range, 0,1)

            Else ;/ further than header line
              Range.s = Export_Excel_CellFromRC(1,Online)+":"+Export_Excel_CellFromRC(2,Online)
              XLSFunc_SetColor(ExcelObject, Range ,250,250,200)
              XLSFunc_SetBorders(ExcelObject, Range,252,#xlContinuous,#xlThin,0)
              
              Range.s = Export_Excel_CellFromRC(3,Online)+":"+Export_Excel_CellFromRC(16,Online)
              XLSFunc_SetColor(ExcelObject, Range ,250,250,200)
              XLSFunc_SetBorders(ExcelObject, Range,60,#xlContinuous,#xlThin,0)
            EndIf
            
            
            Online + 1
          Next
        EndIf
      EndIf 
      XLSFunc_ExcelVisible(ExcelObject,#True); Nothing to see Excel
    EndIf
  Else
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_ExportingtoExcelisonlysupportedifMicrosoftExcelisinstalled)+".")
  EndIf
EndProcedure

Procedure.i Export_CSV(View.i) ;/ Report = 0, Anilox = 1
  Protected MyLoop.i, File.s, Text.s, Column.i, ColumnCount.i, SM.s, TmpTxt.s, Temp.i, Pattern.s, Seperator.s,Sur.s, ListColumns.i
  
  ListColumns = 10
  If System\Show_Depth = 1
    ListColumns = 11
  EndIf
  
  Debug "Saving CSV"
  
  SM.s = Chr(34) ;/ SpeechMark
  
  Select System\CSVDelimiter
    Case 0 ;/ Comma
      Seperator = ","
    Case 1
      Seperator = Chr(9)
  EndSelect
  
  ;/ if csv delimiter is a comma, and decimal notation is a comma, you must encapsulate the written strings with " marks  
  If System\CSVDelimiter = 0 And System\DecimalNotation = 1
    Sur.s =  Chr(34)
  Else
    Sur = ""
  EndIf
  
;  Sur.s =  Chr(34) ;/TEMP - forc speech mark encapsulation
  
  Pattern.s = "CSV|*.CSV" ;/DNT
  File.s = SaveFileRequester(tTxt(#Str_Enterfilename),"",Pattern,0)
  Debug "File: "+File
  
  If File = "" : ProcedureReturn : EndIf
  
  If FileSize(File) > 0 ;/ file exists, prompt to overwrite)
    If MessageRequester(tTxt(#Str_Message),tTxt(#Str_Fileexists)+", "+tTxt(#Str_overwrite)+"?",#PB_MessageRequester_YesNo) = #PB_MessageRequester_No
      ProcedureReturn 
    EndIf
  EndIf
  If UCase(Right(file,4)) <> ".CSV" : File + ".csv" : EndIf ;/DNT
  
  If CreateFile(1,File)
    Debug "Created File"
    WriteStringFormat(1,#PB_Unicode)

    ColumnCount = GetGadgetColumns(#Gad_Report_ReportList)
    Debug "Columncount: "+Str(ColumnCount)
    WriteStringN(1,tTxt(#Str_ExportfromTroikaSystemsAMSSoftware)+" - "+Program_Version, #PB_Unicode)
    WriteStringN(1,"", #PB_Unicode)
    
    If View = 0 ;/ Report
      For Myloop = 0 To CountGadgetItems(#Gad_Report_ReportList)
        Text = ""
        For Column = 0 To ColumnCount
          Text + Sur + GetGadgetItemText(#Gad_Report_ReportList,MyLoop,Column) + Sur + Seperator
        Next
        ;/remove last comma from text
        Text = Left(Text,Len(Text)-1)
        If Right(Text,1) = Seperator : Text = Left(Text,Len(Text)-1) : EndIf
        WriteStringN(1,Text, #PB_Unicode)
      Next
    EndIf 
    
    If View = 1 ;/ Anilox
      ;/ *Main Data
      ;/RollID, Manufacturer,DateMade, Group Suitability, ScreenCount, WallWidth, CellOpening, RollWidth, Comments
      WriteStringN(1, tTxt(#Str_RollID)+Seperator+ Sur+RollInfo\RollID+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Manufacturer)+Seperator+ Sur+Get_Manufacturer_Text()+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Datemade)+Seperator+UnitConversion_Date(RollInfo\DateMade), #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Group)+Seperator+ Sur+GetGadgetText(#Gad_Rollinfo_Group_Combo)+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Suitability)+Seperator+ Sur+Get_Suitability_Text()+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Screencount)+Seperator+ Sur+RollInfo\Screen+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Wallwidth)+Seperator+ Sur+RollInfo\WallWidth+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Cellopening)+Seperator+ Sur+RollInfo\CellOpening+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Rollwidth)+Seperator+ Sur+RollInfo\RollWidth+ Sur, #PB_Unicode)
      WriteStringN(1, tTxt(#Str_Comments)+Seperator+ Sur+RollInfo\Comments+ Sur, #PB_Unicode)
      
      ;/ General history
      WriteStringN(1,"", #PB_Unicode)
      WriteStringN(1,tTxt(#Str_Generalhistory)+":", #PB_Unicode)
      For MyLoop = 0 To CountGadgetItems(#Gad_RollInfo_GeneralHistory_History_List)
        Text = ""
        For Column = 0 To 2
          Text +  Sur+GetGadgetItemText(#Gad_RollInfo_GeneralHistory_History_List,MyLoop,Column)+ Sur+Seperator
        Next
        WriteStringN(1,Text, #PB_Unicode)
      Next
      
      ;/ *Original Readings
      WriteStringN(1,"", #PB_Unicode)
      WriteStringN(1,tTxt(#Str_Referencereading)+":", #PB_Unicode)
      Pattern = "Vol 1"+Seperator+"Vol 2"+Seperator+"Vol 3"+Seperator+"Vol 4"+Seperator+"Vol 5" ;/DNT
      WriteStringN(1,tTxt(#Str_Date)+Seperator+tTxt(#Str_Examiner)+Seperator+Pattern+Seperator+"="+Seperator+System\Settings_Volume_UnitMask+Seperator+tTxt(#Str_Variance)+Seperator+tTxt(#Str_Capacity), #PB_Unicode)
      Text = ""
      For Column = 0 To 11
        Text + Sur+GetGadgetItemText(#Gad_RollInfo_Original_List,1,Column)+Sur+Seperator
      Next
      WriteStringN(1,Text, #PB_Unicode)
      
      ;/ *Historical Readings
      WriteStringN(1,"", #PB_Unicode)
      WriteStringN(1,tTxt(#Str_Historicalreadings)+":", #PB_Unicode)
      
      Pattern = "Vol 1"+Seperator+"Vol 2"+Seperator+"Vol 3"+Seperator+"Vol 4"+Seperator+"Vol 5" ;/DNT
      WriteStringN(1,tTxt(#Str_Date)+Seperator+tTxt(#Str_Examiner)+Seperator+Pattern+Seperator+"="+Seperator+System\Settings_Volume_UnitMask+Seperator+tTxt(#Str_Variance)+Seperator+tTxt(#Str_Capacity), #PB_Unicode)
      
      For MyLoop = 0 To CountGadgetItems(#Gad_RollInfo_History_List)
        Text = ""
        For Column = 0 To 11
          Text + Sur + GetGadgetItemText(#Gad_RollInfo_History_List,MyLoop,Column)+ Sur + Seperator
        Next
        WriteStringN(1,Text, #PB_Unicode)
      Next
      ;/ Date, Examiner, Vol1-2-3-4-5, '=' cm3/m2,variance,capacity.
      
    EndIf
    MessageRequester("",tTxt(#Str_ExporttoCSVcompleted))
  Else
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_Cannotwritetofile)+", "+tTxt(#Str_filealreadyopenelsewhere)+"?",#PB_MessageRequester_Ok)
    ProcedureReturn 
  EndIf
  
  CloseFile(1)
  
EndProcedure

Procedure Init_About(parent)
  Protected nf.S, nl.S, Txt.S,about.S, Name.S, corp.S, url.S, lnk.S, flags.i, img1.i, X.i,Y.i, ndx.i, icon.i, btn1.i, lnk1.i, img2.i, img3.i, win.i, res.S, Exit.i

  nf.S = Chr(8)

  nl.S = Chr(13) + Chr(10)

  Txt.S = "Anilox Management System (AMS)" + nf ;/DNT

  Txt + "" + nf
  ;company field
  ;Txt + "Troika Systems 2012" + nf ;/DNT
  Txt + nf
  ;main text field
  ;Txt + "Troika Systems "+Chr(169)+" 2012" + nl + nl ;/DNT
  If Multi_Site_Mode = 0
    Txt + "Version: "+Program_Version + " - [Rl: "+Str(System\Settings_RollLimit)+" / Rd: "+Str(System\Settings_ReadingsLimit)+"]"+nl+nl ;/DNT
  Else
    Txt + "Version: "+Program_Version + " - [Rl: "+Str(System\Settings_RollLimit)+" / Rd: "+Str(System\Settings_ReadingsLimit)+" / St: "+Str(System\Settings_SiteLimit)+"]"+nl+nl ;/DNT
  EndIf
  
  Txt + "Copyright "+Chr(169)+" 2008 - 2014 Troika Systems" + nl + nl ;/DNT
  Txt + "This program is licensed to:" + nl ;/DNT
  Txt + System\Database_Company + nl + nl
  Txt + "Database Location: " + nl
  Txt + System\Database_Path + nl + nf  ;/DNT
  
  ;online link field
  Txt + "Visit Troika Systems online at:" + nf ;/DNT
  url = "http://www.troika-systems.com" ;/DNT
  ;field delimiter
  nf.S = Chr(8)
  ;fields
  about.S = StringField(Txt, 1, nf)
  Name.S = StringField(Txt, 2, nf)
  corp.S = StringField(Txt, 3, nf)
  Txt.S = StringField(Txt, 4, nf)
;  url.S = StringField(Txt, 5, nf)
  lnk.S = StringField(Txt, 6, nf)
  
  flags = #PB_Window_WindowCentered  | #PB_Window_SystemMenu
  win = OpenWindow(#PB_Any, 0, 0, 420, 325, Name, flags,WindowID(#Window_Main))
  If win
;    EnableWindow_(WindowID(parent), #False)
    StickyWindow(win, #True)
    ResizeWindow(win, #PB_Ignore, WindowY(win) - 50, #PB_Ignore, #PB_Ignore) 
    ResizeWindow(win, #PB_Ignore, WindowY(win) - 50, 420,325) 

      img1 = CreateImage(#PB_Any, 420, 70)
      LoadFont(100, "", 10)
      LoadFont(101, "", 16)
      If StartDrawing(ImageOutput(img1))
          DrawingMode(#PB_2DDrawing_Transparent)
          
          ;header background gradient
          For X = 0 To 419
            LineXY(X, 0, X, 60, RGB(X / 2.5, X / 2.5, 255))
            LineXY(X, 60, X, 70, RGB(225- X / 5, 225 - X / 5, 255))
          Next X
          
          DrawingMode(#PB_2DDrawing_AlphaBlend)
            DrawImage(ImageID(#Image_Logo), 0, 0, ImageWidth(#Image_Logo)/1.275, ImageHeight(#Image_Logo)/1.275)
          DrawingMode(#PB_2DDrawing_Transparent)
          
          ;header about field
          DrawingFont(FontID(100))
          Debug "*** about: "+about
          DrawText(190, 10, about, RGB(255, 255, 255))

          ;header company name field
          DrawingFont(FontID(100))

          DrawText(400 - TextWidth(corp), 35, corp, RGB(255, 255, 255))
        StopDrawing()
      EndIf
      
      ImageGadget(#PB_Any, 0, 0, 0, 0, ImageID(img1))
      
      ;text icon
      img2 = CreateImage(#PB_Any, ImageWidth(#Image_AniCAM)/1.5, ImageHeight(#Image_AniCAM)/1.5)
      If StartDrawing(ImageOutput(img2))
          Box(0, 0, ImageWidth(#Image_AniCAM)/1.5, ImageHeight(#Image_AniCAM)/1.5, GetSysColor_(15))

          DrawingMode(#PB_2DDrawing_AlphaBlend)
          DrawImage(ImageID(#Image_AniCAM), 0, 0, ImageWidth(#Image_AniCAM)/1.5, ImageHeight(#Image_AniCAM)/1.5)
          DrawingMode(#PB_2DDrawing_Default)

        StopDrawing()
      EndIf
      ImageGadget(#PB_Any, 20, 100, 0, 0, ImageID(img2))
      
      ;text
      TextGadget(#PB_Any, 70, 100, 330, 145, Txt)
      
      ;divider line
      img3 = CreateImage(#PB_Any, 410, 2)
      If StartDrawing(ImageOutput(img3))
          Line(0, 0, 420, 0, RGB(160, 160, 160))
          Line(0, 1, 420, 0, RGB(255, 255, 255))
        StopDrawing()
      EndIf
      ImageGadget(#PB_Any, 10, 260, 0, 0, ImageID(img3))
      
      ;online link
      If Len(url)
        lnk1 = HyperLinkGadget(#PB_Any, 20, 275, 200, 24, url, RGB(0, 0, 255), #PB_HyperLink_Underline)
        SetGadgetColor(lnk1, #PB_Gadget_FrontColor, RGB(0, 0, 255))
      EndIf
      
      ;ok button
      btn1 = ButtonGadget(#PB_Any, 330, 288, 80, 24, tTxt(#Str_OK), #PB_Button_Default)
      SetActiveGadget(btn1)

    
    Repeat
      event = WaitWindowEvent()
      Select event
        Case #PB_Event_Gadget
          Select EventGadget()
            Case lnk1
              RunProgram(lnk)
              Exit = #True
            Case btn1
              Exit = #True
          EndSelect
        Case #PB_Event_CloseWindow
          Exit = #True
      EndSelect
    Until Exit
    
    CloseWindow(win)
  EndIf
  EnableWindow_(WindowID(parent), #True)
  SetActiveWindow(parent)
EndProcedure

Procedure Image_FullScreen_Grab(Delay.i)
  Protected x_win.i, y_win.i, srcDC.l, trgDC.l, BMPHandle.l, dm.devmode, left.i, top.i, width.i, height.i, MyImage.i, Ratio.f, MaxSize.i, XPos.i, YPos.i
  Protected File.s, Extension.s, OutlookObject.ComateObject, Sub.s, Standard.s, ToMail.s, Add.s, OlMsg.ComateObject, ImageFormat.i
  left=WindowX(#Window_Main) + GadgetX(#Gad_LHS_Container) + GadgetWidth(#Gad_LHS_Container)+WindowBorder(#Window_Main)
  Top=WindowY(#Window_Main) + WindowBorder(#Window_Main) + WindowTitleBar(#Window_Main)
  Width = WindowRealWidth(#Window_Main) - ((WindowBorder(#Window_Main)*2) + GadgetX(#Gad_LHS_Container) + GadgetWidth(#Gad_LHS_Container))
  Height = WindowRealHeight(#Window_Main) - ((WindowBorder(#Window_Main)*2) + WindowTitleBar(#Window_Main) + 20)

  #CAPTUREBLT = $40000000
  
  Delay(Delay)
  
  srcDC = CreateDC_ ( "DISPLAY" , "" , "" , dm) ;/DNT
  trgDC = CreateCompatibleDC_ (srcDC)
  BMPHandle = CreateCompatibleBitmap_ (srcDC, Width, Height)
  SelectObject_ ( trgDC, BMPHandle)
  BitBlt_ ( trgDC, 0, 0, Width, Height, srcDC, left , top, #SRCCOPY|#CAPTUREBLT )
  
  If IsImage(#Image_FullScreen) : FreeImage(#Image_FullScreen) : EndIf
  If CreateImage (#Image_FullScreen ,Width,Height)
    If StartDrawing ( ImageOutput ( #Image_FullScreen ))
      DrawImage (BMPHandle,0,0)
    EndIf 
    StopDrawing ()
  EndIf 
  
  DeleteDC_ ( trgDC)
  ReleaseDC_ ( BMPHandle, srcDC)
EndProcedure

Procedure Export_Image(Output.i) ; 1 = clipboard, 2 = email, 3 = file
  Protected x_win.i, y_win.i, srcDC.l, trgDC.l, BMPHandle.l, dm.devmode, left.i, top.i, width.i, height.i, MyImage.i, Ratio.f, MaxSize.i, XPos.i, YPos.i
  Protected File.s, Extension.s, OutlookObject.ComateObject, Sub.s, Standard.s, ToMail.s, Add.s, OlMsg.ComateObject, ImageFormat.i, Pattern.s
  
  Select Output ;/ To File
    Case 1 ;/ clipboard
      SetClipboardImage(#Image_FullScreen)
      MessageRequester(tTxt(#Str_Message)+":",tTxt(#Str_Screenhasbeencopiedtotheclipboard))
    Case 2 ;/ Email
      
      sub.s="Troika-Systems - AMS " ;/DNT
      Sub + tTxt(#Str_Export)
      
      ;standard.s= "Image extracted from Troika-Systems' AMS"
      tomail.s=""
      If SaveImage(#Image_FullScreen,GetTemporaryDirectory()+"AMS Export.jpg",#PB_ImagePlugin_JPEG,8) ;/DNT
        Add.s = GetTemporaryDirectory()+"AMS Export.jpg" ;/ File to add ;/DNT
        
        OutlookObject = COMate_CreateObject("Outlook.Application")  ;/DNT
        
        If OutlookObject 
          
          olMsg = OutlookObject\GetObjectProperty("CreateItem(0)")  ;/DNT
          If olMsg 
            olMsg\SetProperty("to='"+tomail+"'")  ;/DNT
            olMsg\SetProperty("Subject='"+sub+"'")  ;/DNT
            olMsg\SetProperty("Body='"+standard+"'")  ;/DNT
            
            If FileSize(add)<>-1
              olMsg\Invoke("Attachments\Add('"+add+"')") ;/DNT
            EndIf
            
            olMsg\Invoke("Display")  ;/DNT
            olMsg\Release() 
          Else 
            MessageRequester("Sorry", COMate_GetLastErrorDescription())  ;/DNT
          EndIf 
          OutlookObject\Release()  
        Else 
          ;MessageRequester("Sorry - CreateObject", COMate_GetLastErrorDescription()) 
        EndIf
      Else
        MessageRequester(tTxt(#Str_Sorry),tTxt(#Str_TheAMSprogramwasunabletosaveatemporarycopyoftheimage))
      EndIf
    
    Case 3 ;/ File
      Pattern = "BMP Format|*.bmp|JPEG Format|*.jpg|PNG Format|*.png" ;/DNT
      File = SaveFileRequester(tTxt(#Str_Saveapicture), Left(File, Len(File)-Len(GetExtensionPart(File))-1), Pattern, 0)
      
      If File
        
        Select SelectedFilePattern()
            
          Case 0  ; BMP
            ImageFormat = #PB_ImagePlugin_BMP
            Extension  = "bmp" ;/DNT
            
          Case 1  ; JPG
            ImageFormat = #PB_ImagePlugin_JPEG
            Extension  = "jpg" ;/DNT
            
          Case 2  ; PNG
            ImageFormat = #PB_ImagePlugin_PNG
            Extension  = "png" ;/DNT
            
        EndSelect
        
        If LCase(GetExtensionPart(File)) <> Extension
          File + ""+"." + Extension
        EndIf
        
        If SaveImage(#Image_FullScreen, File, ImageFormat)
          MessageRequester(tTxt(#Str_Information), tTxt(#Str_Imagesavedsuccessfully), 0)
        Else
          MessageRequester(tTxt(#Str_Information), tTxt(#Str_Therewasanerrorsaving)+":"+" "+file, 0)
        EndIf
      EndIf
      
  EndSelect
  
EndProcedure

Procedure Init_FullScreen() ;/ Full screen quickviewer
  Protected x_win.i, y_win.i, srcDC.l, trgDC.l, BMPHandle.l, dm.devmode, left.i, top.i, width.i, height.i, MyImage.i, Ratio.f, MaxSize.i, XPos.i, YPos.i
  
  left=WindowX(#Window_Main) + GadgetX(#Gad_LHS_Container) + GadgetWidth(#Gad_LHS_Container)+WindowBorder(#Window_Main)
  Top=WindowY(#Window_Main) + WindowBorder(#Window_Main) + WindowTitleBar(#Window_Main)
  Width = WindowRealWidth(#Window_Main) - ((WindowBorder(#Window_Main)*2) + GadgetX(#Gad_LHS_Container) + GadgetWidth(#Gad_LHS_Container))
  Height = WindowRealHeight(#Window_Main) - ((WindowBorder(#Window_Main)*2) + WindowTitleBar(#Window_Main) + 20)
  
  Ratio = Width / Height
  Debug Width
  Debug Height
  Debug "Ratio: "+StrF(Ratio,1)
  #CAPTUREBLT = $40000000
 
  srcDC = CreateDC_ ( "DISPLAY" , "" , "" , dm) ;/DNT
  trgDC = CreateCompatibleDC_ (srcDC)
  BMPHandle = CreateCompatibleBitmap_ (srcDC, Width, Height)
  SelectObject_ ( trgDC, BMPHandle)
  BitBlt_ ( trgDC, 0, 0, Width, Height, srcDC, left , top, #SRCCOPY|#CAPTUREBLT )
  
  If IsImage(#Image_FullScreen) : FreeImage(#Image_FullScreen) : EndIf
  If CreateImage (#Image_FullScreen ,Width,Height)
    If StartDrawing ( ImageOutput ( #Image_FullScreen ))
      DrawImage (BMPHandle,0,0)
    EndIf 
    StopDrawing ()
  EndIf 
  
  DeleteDC_ ( trgDC)
  ReleaseDC_ ( BMPHandle, srcDC)
  
  MaxSize = System\Desktop_Width
  If System\Desktop_Height < MaxSize : MaxSize = System\Desktop_Height : EndIf
  XPos = (System\Desktop_Width-MaxSize) / 2.0
  YPos = (System\Desktop_Height-MaxSize) / 2.0
  
  ResizeImage(#Image_FullScreen,MaxSize,MaxSize)
  
  OpenWindow(#Window_FullScreen,0,0,System\Desktop_Width,System\Desktop_Height,"",#PB_Window_BorderLess,WindowID(#Window_Main))
  
  ImageGadget(#Gad_FullscreenImage,XPos,YPos,System\Desktop_Width,System\Desktop_Height,ImageID(#Image_FullScreen))
  
  Repeat
    WaitWindowEvent()
    
  Until GetAsyncKeyState_(#VK_F11); Or GetAsyncKeyState_(1)
    
  CloseWindow(#Window_FullScreen)
  Repeat : Until GetAsyncKeyState_(#VK_F11) = 0
  Debug "Closed Fullscreen Window"

  ProcedureReturn 
  ; Protected ev.i, Image.i, Width.i, Height.i, StartX.i, StartY.i, X.i, Y.i
  ; Protected HDC.i, MyDC.i, Bm_HND.i
  ; #CAPTUREBLT = $40000000 
; 
  ; Width = 720 : Height = 720 : StartX = 300 : StartY = 12
  ; 
  ; If IsImage(#Image_FullScreen) : FreeImage(#Image_FullScreen) : EndIf
  ; Bm_HND = CreateImage(#Image_FullScreen,Width,Height)
  ; 
  ; MyDC = GetDC_(WindowID(#Window_Main))
  ; 
  ; HDC = StartDrawing(ImageOutput(#Image_FullScreen))
  ; MemDC.i = CreateCompatibleDC_(dcv) 
  ; ;BitBlt_(MyDC, WindowX(#Window_Main)+StartX, WindowY(#Window_Main)+StartY, Width, Height, HDC, 0, 0, #SRCCOPY); | #CAPTUREBLT)      
    ; BitBlt_(MyDC, WindowX(#Window_Main)+StartX, WindowY(#Window_Main)+StartY, Width, Height, HDC, 0, 0, #SRCCOPY | #CAPTUREBLT)      
  ; StopDrawing()
; 
  ; ResizeImage(#Image_FullScreen,1920-1,1200-1)
  ; 
  ; OpenWindow(#Window_FullScreen,0,0,1920-1,1200-1,"",#PB_Window_BorderLess,WindowID(#Window_Main))
  ; ImageGadget(#Gad_FullscreenImage,0,0,1920-1,1200-1,ImageID(#Image_FullScreen))
  ; 
  ; Repeat
    ; ev = WaitWindowEvent()
    ; 
  ; Until GetAsyncKeyState_(#VK_F11); Or GetAsyncKeyState_(1)
    ; 
  ; CloseWindow(#Window_FullScreen)
  ; Repeat : Until GetAsyncKeyState_(#VK_F11) = 0
  ; Debug "Closed Fullscreen Window"
; ;  DeleteDC_( MyDC)
EndProcedure 

Procedure Init_Eula(Agreed.i=0)
  Protected MyLoop.i, Text.s, Event.i, Exit.i, FontN.i, FontB.i, HardwareInfo.s, SystemName.s, UserName.s, Txt.s, HW_Check.s, User_Check.s, System_Check.s, Agree.i
  
  ;/ Retrieve system / user information
  HardwareInfo = HardwareFingerprint()
  SystemName   = GetEnvironmentVariable("COMPUTERNAME")
  UserName     = GetEnvironmentVariable("USERNAME")
  
  ;/ Check for the database Entry here

    Agree = 0
    DatabaseQuery(#Databases_Master,"Select HardwareInfo, SystemName, UserName From AMS_EULA_Agreements;")
    While NextDatabaseRow(#Databases_Master) ; Loop for each records
      If GetDatabaseString(#Databases_Master, 0) = HardWareInfo And GetDatabaseString(#Databases_Master, 1) = SystemName And GetDatabaseString(#Databases_Master, 2) = UserName
        Agree = 1
        Break
      EndIf
    Wend
    FinishDatabaseQuery(#Databases_Master)
    
    
    If Agree = 1 And Agreed = 0 ;/ showing by choice, rather than force  
      ProcedureReturn 
    EndIf

  
  
  
  ;{ EULA text
  Txt.s = "PLEASE READ THIS LICENCE CAREFULLY BEFORE USING THIS SOFTWARE.  BY USING THIS" + Chr(10) 
  Txt.s + "SOFTWARE, YOU AGREE TO BECOME BOUND BY THE TERMS OF THIS LICENCE.  IF YOU DO" + Chr(10) 
  Txt.s + "NOT AGREE TO THE TERMS OF THIS LICENCE, DO NOT USE THIS SOFTWARE AND PROMPTLY" + Chr(10) 
  Txt.s + "RETURN IT TO YOUR SUPPLIER FOR A FULL REFUND." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "The software product within which this agreement is embedded (the Software) is licensed," + Chr(10) 
  Txt.s + "not sold, to you by Troika Systems Ltd. for use only under the terms of this License," + Chr(10) 
  Txt.s + "and Troika Systems Ltd. reserves any rights not expressly granted to you.  You own the" + Chr(10) 
  Txt.s + "media on which the Software is recorded or fixed, but Troika Systems Ltd. and its" + Chr(10) 
  Txt.s + "licensors retain ownership of the Software itself.  " + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "1.  Licence.  This License allows you to:" + Chr(10) 
  Txt.s + "(a)  Use one copy of the Software on a single computer at a time.  To 'use' the Software" + Chr(10) 
  Txt.s + "means that the Software is either loaded in the temporary memory (i.e., RAM) of a computer" + Chr(10) 
  Txt.s + "or installed on the permanent memory of a computer (i.e., hard disk, etc.)." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "(b)  Make one copy of the Software in machine readable form solely for backup purposes. As" + Chr(10) 
  Txt.s + "an express condition of this License, you must reproduce on each copy any copyright notice" + Chr(10) 
  Txt.s + "or other proprietary notice that is on the original copy supplied by Troika Systems Ltd." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "(c)  Permanently transfer all your rights under this License to another party by providing" + Chr(10) 
  Txt.s + "to such party all copies of the Software licensed under this License together with a copy" + Chr(10) 
  Txt.s + "of this License and the accompanying written materials, provided that the other party reads" + Chr(10) 
  Txt.s + "and agrees to accept the terms and conditions of this License." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "2.  Restrictions.  The Software contains trade secrets in its human perceivable form and, to" + Chr(10) 
  Txt.s + "protect them, you may not REVERSE ENGINEER, DECOMPILE, DISASSEMBLE OR OTHERWISE" + Chr(10) 
  Txt.s + "REDUCE THE SOFTWARE TO ANY HUMAN PERCEIVABLE FORM.  YOU MAY NOT MODIFY," + Chr(10) 
  Txt.s + "ADAPT, TRANSLATE, RENT, LEASE, LOAN OR CREATE DERIVATIVE WORKS BASED" + Chr(10) 
  Txt.s + "UPON THE SOFTWARE OR ANY PART THEREOF." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "3.  Termination.  This License is effective until terminated.  This License will terminate" + Chr(10) 
  Txt.s + "immediately without notice from Troika Systems Ltd. or judicial resolution if you fail to" + Chr(10) 
  Txt.s + "comply with any provision of this License.  Upon such termination you must destroy the" + Chr(10) 
  Txt.s + "Software, all accompanying written materials and all copies thereof, and Sections 6, 7 and 8" + Chr(10) 
  Txt.s + "will survive any termination. " + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "4. Passwords. The Software licensed to you contains features which are protected by certain" + Chr(10) 
  Txt.s + "passwords.  You are not authorized to enter, remove or change such passwords, and only" + Chr(10) 
  Txt.s + "Troika Systems Ltd. is authorized to enter, remove or change such passwords. 5. Export Law" + Chr(10) 
  Txt.s + "Assurances.  You agree that neither the Software nor any direct product thereof is being or" + Chr(10) 
  Txt.s + "will be shipped, transferred or re-exported, directly or indirectly, into any country" + Chr(10) 
  Txt.s + "prohibited by the United States Export Administration Act and the regulations thereunder or" + Chr(10) 
  Txt.s + "will be used for any purpose prohibited by the Act. " + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "6. Limited Warranty.  Troika Systems Ltd. warrants for a period of one hundred and eighty" + Chr(10) 
  Txt.s + "(180) days from your date of purchase that (i) the media on which the Software is recorded" + Chr(10) 
  Txt.s + "will be free from defects in materials and workmanship under normal use, and (ii) the" + Chr(10) 
  Txt.s + "Software as provided by Troika Systems Ltd will substantially conform to Troika Systems" + Chr(10) 
  Txt.s + "Ltd.�s published specifications for the Software.  Troika Systems Ltd's entire liability" + Chr(10) 
  Txt.s + "and your sole and exclusive remedy for any breach of the foregoing limited warranty will" + Chr(10) 
  Txt.s + "be, at Troika Systems Ltd's option, replacement of the media, refund of the purchase" + Chr(10) 
  Txt.s + "price or repair or replacement of the Software." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "THIS LIMITED WARRANTY IS THE ONLY WARRANTY PROVIDED BY TROIKA SYSTEMS LTD. AND" + Chr(10) 
  Txt.s + "TROIKA SYSTEMS LTD. AND ITS LICENSORS EXPRESSLY DISCLAIM ALL OTHER WARRANTIES," + Chr(10) 
  Txt.s + "EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF" + Chr(10) 
  Txt.s + "MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE WITH REGARD TO THE" + Chr(10) 
  Txt.s + "SOFTWARE AND ACCOMPANYING WRITTEN MATERIALS.  BECAUSE SOME JURISDICTIONS DO" + Chr(10) 
  Txt.s + "NOT ALLOW THE EXCLUSION OR LIMITATION OF IMPLIED WARRANTIES, THE ABOVE" + Chr(10) 
  Txt.s + "LIMITATION MAY NOT APPLY TO YOU." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "7.  Limitation of Remedies and Damages.  In no event will Troika Systems Ltd., its parent or" + Chr(10) 
  Txt.s + "subsidiaries or any of the licensors, directors, officers, employees or affiliates of any of the" + Chr(10) 
  Txt.s + "foregoing be liable to you for any consequential, incidental, indirect or special damages" + Chr(10) 
  Txt.s + "whatsoever (including, without limitation, damages for loss of business profits, business" + Chr(10) 
  Txt.s + "interruption, loss of business information and the like), whether foreseeable or unforeseeable," + Chr(10) 
  Txt.s + "arising out of the use of or inability to use the Software or accompanying written materials," + Chr(10) 
  Txt.s + "regardless of the basis of the claim and even if Troika Systems Ltd. or a Troika Systems Ltd." + Chr(10) 
  Txt.s + "representative has been advised of the possibility of such damage.  Troika Systems Ltd's" + Chr(10) 
  Txt.s + "liability to you for direct damages for any cause whatsoever, and regardless of the form of the" + Chr(10) 
  Txt.s + "action, will be limited to the money paid for the Software that caused the damages." + Chr(10) 
  Txt.s + "" + Chr(10) 
  Txt.s + "8. General.  This License will be construed under the laws of England and Wales, except for that" + Chr(10) 
  Txt.s + "body of law dealing with conflicts of law.  If any provision of this License shall be held by a" + Chr(10) 
  Txt.s + "court of competent jurisdiction to be contrary to law, that provision will be enforced to the" + Chr(10) 
  Txt.s + "maximum extent permissible, and the remaining provisions of this License will remain in full" + Chr(10) 
  Txt.s + "force and effect." + Chr(10) 
  Txt.s + "" + Chr(10) 

  ;}
  
  ;/ Query AMS_EULA_Agreements table, Fields:  HardwareInfo, SystemName, UserName
  ;/     "Select Count(*) from AMS_EULA_Agreements Where HardwareInfo = "+HardwareInfo+", SystemName = "+SystemName+", UserName = "+UserName+";"
  ;/      If Count returns > 0, record exists, exit routine
  ;/      Otherwise, show licencing agreement window

  
  FontN = LoadFont(#PB_Any,"Arial",8)
  FontB = LoadFont(#PB_Any,"Arial",8,#PB_Font_Bold)
  
  OpenWindow(#Window_EULA,0,0,580,480,"Troika Systems AMS, End-User Licence Agreement",#PB_Window_ScreenCentered)
  SetGadgetFont(#PB_Default,FontID(FontN))
  ContainerGadget(#Gad_EULA_ContainerGadget,0,0,580,70)
  SetGadgetColor(#Gad_EULA_ContainerGadget,#PB_Gadget_BackColor,RGB(255,255,255))
  
  TextGadget(#Gad_EULA_LicenceAgreement_Text,20,20,200,20,"License Agreement:")
  SetGadgetColor(#Gad_EULA_LicenceAgreement_Text,#PB_Gadget_BackColor,RGB(255,255,255))
  SetGadgetFont(#Gad_EULA_LicenceAgreement_Text, FontID(FontB))
  TextGadget(#Gad_EULA_DoYouAccept_Text,50,42,400,20,"Do you accept the terms of the licencing agreement for Troika Systems AMS?")
  SetGadgetColor(#Gad_EULA_DoYouAccept_Text,#PB_Gadget_BackColor,RGB(255,255,255))
  CloseGadgetList()

  FrameGadget(#Gad_EULA_TopBox,0,71,500,2,"")
  
  Text.s = "Please read throught the following Licence Agreement.  In order to use the Troika Systems AMS application, you must accept this agreement."
  
  TextGadget(#Gad_EULA_PleaseRead,50,90,390,40,Text)
  EditorGadget(#Gad_EULA_Editor,50,130,500,250,#PB_Editor_ReadOnly)
  
  Text = "Hardware FingerPrint: "+HardwareFingerprint() + Chr(10)
  Text + "System Name: "+GetEnvironmentVariable("COMPUTERNAME") + Chr(10)
  Text + "User Name: "+GetEnvironmentVariable("USERNAME") + Chr(10)
  Text + "AGREE To THE TERMS OF THIS LICENCE, DO Not USE THIS SOFTWARE And PROMPTLY Return" + Chr(10)
  
  SetGadgetText(#Gad_EULA_Editor,txt)

  OptionGadget(#Gad_EULA_IAcceptAgreement,50,390,400,20,"I accept the terms in the End-User-Licence Agreement")
  OptionGadget(#Gad_EULA_IDonotAcceptAgreement,50,412,400,20,"I don't accept the terms in the End-User-Licence Agreement")
  SetGadgetState(#Gad_EULA_IDonotAcceptAgreement,1)
  
  If Agreed = 1
    SetGadgetState(#Gad_EULA_IDonotAcceptAgreement,0)
    SetGadgetState(#Gad_EULA_IAcceptAgreement,1)
    DisableGadget(#Gad_EULA_IDonotAcceptAgreement,1)
    DisableGadget(#Gad_EULA_IAcceptAgreement,1)
  EndIf
  
  FrameGadget(#Gad_EULA_BottomSeperator,0,440,580,2,"")
  
  ButtonGadget(#Gad_EULA_Continue,400,450,80,24,"Continue")
  
  Exit.i = 0
  
  Repeat
    Event = WaitWindowEvent()
    
    If Event = #PB_Event_Gadget
      Select EventGadget()
        Case #Gad_EULA_Continue
          Exit = 1
      EndSelect
    EndIf

  Until Exit > 0

  If GetGadgetState(#Gad_EULA_IAcceptAgreement) = 0
    MessageRequester("Sorry","The application must now exit, due to the non-acceptance of the licencing agreement")
    ;ProcedureReturn
    End
  EndIf
  FreeFont(FontN)
  FreeFont(FontB)
  CloseWindow(#Window_EULA)
  If Agreed = 0
    ;MessageRequester("Okay","Accepted the agreement"+Chr(10)+Chr(10)+"Store Hardware fingerprint, system name & user name in database")
    Database_Update(#Databases_Master,"Insert Into AMS_EULA_Agreements (HardwareInfo, SystemName, UserName, DateAgreed) Values ('"+FormatTextMac(HardwareInfo)+"','"+FormatTextMac(SystemName)+"','"+FormatTextMac(UserName)+"',"+Str(Date())+");",#PB_Compiler_Line)
    ;/ Insert new database record here
    
  EndIf
  SetGadgetFont(#PB_Default,FontID(#Font_List_S))
EndProcedure

Procedure.i Handle_2d_Analysis(View.i)
  Protected Mouse.Point, PosX.i, Posy.i

  ;/ View = 0: Reference - View = 1: Historical.
  If View = 0
    If #Image_2d_Image_Reference <> 0
      CopyImage(#Image_2d_Image_Reference,#Image_2d_Analysis)
      If System\Zoom_2d > 0
        GrabImage(#Image_2d_Image_Reference,#Image_2d_Analysis,System\Zoom_2d,System\Zoom_2d,640-System\Zoom_2d,480-System\Zoom_2d)
        ResizeImage(#Image_2d_Analysis,636,476)
      EndIf
      SetGadgetState(#Gad_2D_Analysis_Image,ImageID(#Image_2d_Analysis))
    EndIf
  EndIf
  If View = 1
    If #Image_2d_Image_Current <> 0
      CopyImage(#Image_2d_Image_Current,#Image_2d_Analysis)
      If System\Zoom_2d > 0
        GrabImage(#Image_2d_Image_Current,#Image_2d_Analysis,System\Zoom_2d,System\Zoom_2d,640-System\Zoom_2d,480-System\Zoom_2d)
        ResizeImage(#Image_2d_Analysis,636,476)
      EndIf
      SetGadgetState(#Gad_2D_Analysis_Image,ImageID(#Image_2d_Analysis))
    EndIf
  EndIf
  
  If View = -1 ;/ update zoom image
    PosX = (WindowMouseX(#Window_Main) - GadgetX(#Gad_2D_Analysis_Image)) - 15
    PosY = (WindowMouseY(#Window_Main) - GadgetY(#Gad_2D_Analysis_Image)) - 15
    ;Debug Str(Posx)+" - "+Str(Posy)
    
    If Posx < -16 Or Posx > 656 : ProcedureReturn : EndIf
    If PosY < -16 Or PosY > 496 : ProcedureReturn : EndIf
    
    If Posx < 0 : Posx = 0 : EndIf
    If Posx > 640 : Posx = 640 : EndIf
    
    If PosY < 0 : PosY = 0 : EndIf
    If PosY > 480 : PosY = 480 : EndIf
    
    GrabImage(#Image_2d_Analysis,#Image_2d_Scaled,PosX,PosY,32,32)
    
    StartDrawing(ImageOutput(#Image_2d_Scaled))
      ;Plot(15,15,RGB(255,0,0))  
      Plot(16,15,RGB(255,0,0))  
      ;Plot(17,15,RGB(255,0,0))  
      ;Plot(15,17,RGB(255,0,0))  
      Plot(16,17,RGB(255,0,0))  
      ;Plot(17,17,RGB(255,0,0))       
      
      Plot(15,16,RGB(255,0,0))  
      Plot(17,16,RGB(255,0,0)) 
      
    StopDrawing()
    ResizeImage(#Image_2d_Scaled,128,128)

    SetGadgetState(#Gad_2D_Analysis_Image_Mag,ImageID(#Image_2d_Scaled))
    
  EndIf
  
EndProcedure

Procedure Init_Menu_Refresh(Site.i)
  Protected Result.S, SQL.S
  Debug "Refreshing popup for site: "+Str(Site)
  SQL.S = "Select GroupName From AMS_Groups Where SiteID = '"+Str(Site)+"';"
  
  FreeMenu(3)
  
  ClearList(GroupList())
  
  ;/ Populate Group List
  If DatabaseQuery(#Databases_Master,SQL.S)
    
    While NextDatabaseRow(#Databases_Master)  
      AddElement(GroupList())
      Result.S = GetDatabaseString(#Databases_Master,0) 
      GroupList()\Name = Result
      Debug "Adding: "+Result+" To Grouplist"
    Wend 
  Else
    MessageRequester(tTxt(#Str_ErrorwithSQL)+"?"+" "+SQL, DatabaseError())
    FinishDatabaseQuery(#Databases_Master)
    ProcedureReturn 
  EndIf

  If CreatePopupMenu(3) ;/ Roll Level
    OpenSubMenu(tTxt(#Str_Assignrolltogroup))  
    ForEach GroupList()
      MenuItem(#Menu_Popup_GroupBase+ListIndex(GroupList()),GroupList()\Name)
    Next
    CloseSubMenu()
    MenuItem(#Menu_Popup3_Roll_Unassign, tTxt(#Str_Unassignrollfromgroup)) 
    MenuBar()
    MenuItem(#Menu_Popup3_Roll_Delete, tTxt(#Str_Deleteroll))
  EndIf
EndProcedure
Procedure Init_Menu()
  
  ;/ create menu
  CreateMenu(99,WindowID(#Window_Main))
  MenuTitle(tTxt(#Str_File))
  OpenSubMenu(tTxt(#Str_Export)+"...")
  
  MenuItem(#Menu_File_Export_PDF,tTxt(#Str_ExporttoPDF))
  MenuItem(#Menu_File_Export_CSV,tTxt(#Str_ExporttoCSV))
  MenuItem(#Menu_File_Export_XLS,tTxt(#Str_ExporttoXLS))
  OpenSubMenu(tTxt(#Str_Exportimageto)+"...")
  MenuItem(#Menu_File_Export_Image_File,tTxt(#Str_File))
  MenuItem(#Menu_File_Export_Image_ClipBoard,tTxt(#Str_Clipboard))
  MenuItem(#Menu_File_Export_Image_Email,tTxt(#Str_Email))
  CloseSubMenu()
  
  CloseSubMenu()
;  MenuBar()
  
;  MenuItem(#Menu_File_PrintPreview,tTxt(#Str_Printpreview)+"...")
;  MenuItem(#Menu_File_Print,tTxt(#Str_Print)+"...")
  
;  MenuBar()
  
  MenuItem(#Menu_File_Quit,tTxt(#Str_Quit))
  MenuTitle(tTxt(#Str_Options))
  MenuItem(#Menu_Options_Settings,tTxt(#Str_Settings)+"...")
  MenuItem(#Menu_Options_MassMove,tTxt(#Str_Move)+"...")
  ;
;  MenuBar()
  ;MenuItem(#Menu_Options_Admin_Mode,"Debug: Test RollID Refresh")
  
;  OpenSubMenu("Edit...")       ; begin sub-menu
;    MenuItem( #Menu_Options_Edit_Manufacturers, "Manufacturer list")
;    MenuItem( #Menu_Options_Edit_Suitability, "Suitability types")
;  CloseSubMenu()  
;  MenuBar()
;  MenuItem(#Menu_Options_Admin_Mode,"Administration Mode...")
;  MenuItem(#Menu_Options_Superuser_Mode,"Superuser Mode...")
  
  MenuTitle(tTxt(#Str_Help))
  MenuItem(#Menu_Help_About,tTxt(#Str_About)+"...")
  MenuBar()
  MenuItem(#Menu_Help_ViewEULA,tTxt(#Str_ShowLicenceAgreement))
  MenuBar()
  MenuItem(#Menu_Help_CheckForUpdates,tTxt(#Str_Checkforupdate)+"...")
  MenuBar()
  OpenSubMenu(tTxt(#Str_Licencecode)+"...") 
  ;(tTxt(#Str_Export)+"...")
  
  MenuItem(#Menu_Help_Input_Code_Export,tTxt(#Str_Export))
  MenuItem(#Menu_Help_Input_Code_Import,tTxt(#Str_Import))
  
  If CreatePopupMenu(0) ;/ Company Level
    ;MenuItem(#Menu_Popup0_Company_Rename, "Rename Company")
    ;MenuBar()
    ;    MenuItem(#Menu_Popup0_Edit_CompanyInfo, tTxt(#Str_Editcompanydetails))
    ;    MenuBar()
    If Multi_Site_Mode = 1 Or Multi_ForPhil = 1 ;/ (MS in Executable name)
      MenuItem(#Menu_Popup0_Add_Site, tTxt(#Str_Newsite))
    EndIf
   
  EndIf

  If CreatePopupMenu(1) ;/ Site Level
    MenuItem(#Menu_Popup1_Add_Group, tTxt(#Str_Createnewgroup))  
    ;   MenuBar()
    ;    MenuItem(#Menu_Popup1_Show_SiteInfo, tTxt(#Str_Showsiteinformation))
    MenuBar()
    MenuItem(#Menu_Popup1_Edit_SiteName, tTxt(#Str_Editsitename))
    ;    MenuItem(#Menu_Popup1_Edit_SiteInfo, tTxt(#Str_Editsiteinformation))
    MenuBar()
    If Multi_Site_Mode = 1 Or Multi_ForPhil = 1
      MenuItem(#Menu_Popup1_SetasDefaultSite, tTxt(#Str_SetchosenSiteasyourdefaultsite))
      MenuBar()
      OpenSubMenu(tTxt(#Str_Deleteselectedsite))
      OpenSubMenu(tTxt(#Str_AreyouSure)+"?")
      MenuItem(#Menu_Popup1_Delete_Site,tTxt(#Str_Yes))
    EndIf
    
  EndIf
  
  If CreatePopupMenu(2) ;/ Group Level
    MenuItem(#Menu_Popup2_Add_Roll, tTxt(#Str_Createnewroll))  
    MenuBar()
    MenuItem(#Menu_Popup2_Group_Rename, tTxt(#Str_Renameselectedgroup)) 
    MenuBar()
    MenuItem(#Menu_Popup2_Group_Delete, tTxt(#Str_Deleteselectedgroup))  
  EndIf
  
  If CreatePopupMenu(3) ;/ Roll Level
    MenuItem(#Menu_Popup3_Roll_Assign, tTxt(#Str_Assignrolltogroup))  
    MenuItem(#Menu_Popup3_Roll_Unassign, tTxt(#Str_Unassignrollfromgroup)) 
    MenuBar()
    MenuItem(#Menu_Popup3_Roll_Rename, tTxt(#Str_Renameselectedroll)) 
    MenuBar()
    MenuItem(#Menu_Popup3_Roll_Delete, tTxt(#Str_Deleteroll))
  EndIf
  
  If CreatePopupMenu(5)
    MenuItem(#Menu_Popup5_GeneralHistory_Insert,tTxt(#Str_Insertnewrecord))
    MenuItem(#Menu_Popup5_GeneralHistory_Edit,tTxt(#Str_Editrecord))
    MenuBar()
    MenuItem(#Menu_Popup5_GeneralHistory_Delete,tTxt(#Str_Deleteselectedrecord))
  EndIf
  
  If CreatePopupMenu(6) ;/ Original
    MenuItem(#Menu_Popup6_Original_Reading_Insert,tTxt(#Str_Insertnewreading))
    MenuItem(#Menu_Popup6_Original_Reading_Edit,tTxt(#Str_Editreadingrecord))
    MenuBar()
    MenuItem(#Menu_Popup6_Original_Reading_Delete,tTxt(#Str_Deleteselectedreadingrecord))
  EndIf
  
  If CreatePopupMenu(7) ;/ Historical
    MenuItem(#Menu_Popup7_Historical_Reading_Insert,tTxt(#Str_Insertnewreading))
    MenuItem(#Menu_Popup7_Historical_Reading_Edit,tTxt(#Str_Editreadingrecord))
    MenuBar()
    MenuItem(#Menu_Popup7_Historical_Reading_Delete,tTxt(#Str_Deleteselectedreadingrecord))
  EndIf
  
  If CreatePopupMenu(8) ;/ Manufacturer
    MenuItem(#Menu_Popup8_Manufacturer_Insert,tTxt(#Str_Insertnewmanufacturer))
    MenuItem(#Menu_Popup8_Manufacturer_Edit,tTxt(#Str_Editmanufacturername))
    MenuBar()
    MenuItem(#Menu_Popup8_Manufacturer_Delete,tTxt(#Str_Deletemanufacturer))
  EndIf
  
  If CreatePopupMenu(9) ;/ Suitability
    MenuItem(#Menu_Popup9_Suitability_Insert,tTxt(#Str_Insertnewsuitabilitytype))
    MenuItem(#Menu_Popup9_Suitability_Edit,tTxt(#Str_Editsuitabilityname))
    MenuBar()
    MenuItem(#Menu_Popup9_Suitability_Delete,tTxt(#Str_Deletesuitabilitytype))
  EndIf

  If CreatePopupMenu(10) ;/ RC Imagery
    MenuItem(#Menu_Popup10_ImportImage, tTxt(#Str_Importimage)+"...")  
    MenuItem(#Menu_Popup10_SaveImage, tTxt(#Str_Saveimage)+"...")
;    MenuBar()
;    MenuItem(#Menu_Popup10_ViewIn2d, tTxt(#Str_Viewscanin2d))  
;    MenuItem(#Menu_Popup10_ViewIn3d, tTxt(#Str_Viewscanin3d)) 
  EndIf
  
  If CreatePopupMenu(11) ;/ RC Imagery
    MenuItem(#Menu_Popup11_ImportImage, tTxt(#Str_Importimage)+"...")  
    MenuItem(#Menu_Popup11_SaveImage, tTxt(#Str_Saveimage)+"...")
;    MenuBar()
;    MenuItem(#Menu_Popup11_ViewIn2d, tTxt(#Str_Viewscanin2d))  
;    MenuItem(#Menu_Popup11_ViewIn3d, tTxt(#Str_Viewscanin3d)) 
  EndIf
  
  If CreatePopupMenu(12)
    MenuItem(#Menu_Popup12_ReportEditor,tTxt(#Str_Editreportfilters))
  EndIf  
  
  If CreatePopupMenu(13)
    MenuItem(#Menu_Popup13_Window_Restore,tTxt(#Str_RestoreAMSwindow)) 
  EndIf
  
  If CreatePopupMenu(14)
    MenuItem(#Menu_Popup14_ImageExport_ToClipBoard,tTxt(#Str_Exportimagetotheclipboard))
    MenuItem(#Menu_Popup14_ImageExport_ToFile,tTxt(#Str_Exportimagetoafile))
    MenuItem(#Menu_Popup14_ImageExport_ToEmail,tTxt(#Str_Exportimagetoemail)+"("+tTxt(#Str_MicrosoftOutlookrequired)+")")
  EndIf
  
EndProcedure

Procedure Init_Window_HomeScreen(SiteID.i=1)
  Protected Y.i = 10, X.i = 290, DateI14.i, DateI6W.i, DateI6m.i, SQL.s, CountI.i
  Protected MidL.i = 400, MidR.i = 410
  
  
  ;ImageGadget(#Gad_Welcome_TroikaLogo,X + 264,Y,202,80,ImageID(#Image_Logo)) : Y + 90
  ImageGadget(#Gad_Welcome_TroikaLogo,X + 130,Y,560,184,ImageID(#Image_TroikaAMS)) : Y + 190
  
  ;  TextGadget(#Gad_Welcome_AMS_Text,X + 4,Y,710,40,"Anilox Management System",#PB_Text_Center) ;/DNT
  ;  : Y + 50 ;/DNT
  ;  SetGadgetFont(#Gad_Welcome_AMS_Text,FontID(#Font_List_L))
  ;  SetGadgetColor(#Gad_Welcome_AMS_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  
  If Multi_Site_Mode = 1
    ;    TextGadget(#Gad_Welcome_AMS_Type,X + 4,Y,710,40,"*** "+tTxt(#Str_Multisiterelease)+" "+"***",#PB_Text_Center) : Y + 50
  Else
    ;    TextGadget(#Gad_Welcome_AMS_Type,X + 4,Y,710,40,"*** "+tTxt(#Str_Singlesiterelease)+" "+"***",#PB_Text_Center) : Y + 50
  EndIf
  
  ;  y+50 
  
  ;  SetGadgetFont(#Gad_Welcome_AMS_Type,FontID(#Font_List_L))
  ;  SetGadgetColor(#Gad_Welcome_AMS_Type,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  If System\Database_Company <> "Flexo Printers"
    TextGadget(#Gad_Welcome_WelcomeText,X + 90,Y,630,60,tTxt(#Str_Welcome),#PB_Text_Center) : Y + 70
    SetGadgetFont(#Gad_Welcome_WelcomeText,FontID(#Font_List_XL))
  Else
    TextGadget(#Gad_Welcome_WelcomeText,X + 90,Y+15,630,60,"Free of Charge: 24 Anilox Licences",#PB_Text_Center) : Y + 70
    SetGadgetFont(#Gad_Welcome_WelcomeText,FontID(#Font_List_XL))
  EndIf
  ;  TextGadget(#Gad_Welcome_WelcomeText,X + 80,Y,630,60,tTxt(#Str_Welcome),#PB_Text_Center) : Y + 70
  ;  SetGadgetFont(#Gad_Welcome_WelcomeText,FontID(#Font_List_XL))
  SetGadgetColor(#Gad_Welcome_WelcomeText,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  SetGadgetColor(#Gad_Welcome_WelcomeText,#PB_Gadget_FrontColor,RGB(60,200,60))
  
  TextGadget(#Gad_Welcome_ClientName_Text,x,Y,MidL,30,tTxt(#Str_Licencedforuseby)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_ClientName_Text,FontID(#Font_List_L_Bold))
  SetGadgetColor(#Gad_Welcome_ClientName_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  ;  SetGadgetColor(#Gad_Welcome_ClientName_Text,#PB_Gadget_FrontColor,RGB(150,50,50))
  
  TextGadget(#Gad_Welcome_ClientName,X + MidR,Y,670,30,"") : Y + 70
  SetGadgetFont(#Gad_Welcome_ClientName,FontID(#Font_List_L_Bold))
  SetGadgetColor(#Gad_Welcome_ClientName,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  SetGadgetColor(#Gad_Welcome_ClientName,#PB_Gadget_FrontColor,RGB(250,50,50))
  
  ;[Name] CHAR, [Location] CHAR,  [Country] CHAR,  [ContactName] CHAR,  [ContactEmail] CHAR,  [ContactNumber] CHAR);"
  TextGadget(#Gad_Welcome_Location_Text,x,Y,MidL,30,tTxt(#Str_Location)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Location_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Location_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Location,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Location,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Location,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  
  Y + 30
  TextGadget(#Gad_Welcome_Country_Text, x,Y,MidL,30,tTxt(#Str_Country)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Country_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Country_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Country,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Country,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Country,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  
  Y + 30
  TextGadget(#Gad_Welcome_Contact_Name_Text,    x,Y,MidL,30,tTxt(#Str_Contactname)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Contact_Name_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Contact_Name_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Contact_Name,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Contact_Name,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Contact_Name,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  
  Y + 30
  TextGadget(#Gad_Welcome_ContactEmail_Text,    x,Y,MidL,30,tTxt(#Str_Contactemail)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_ContactEmail_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_ContactEmail_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_ContactEmail,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_ContactEmail,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_ContactEmail,#PB_Gadget_BackColor,#WinCol_HomeScreen)

  Y + 30
  TextGadget(#Gad_Welcome_Contact_Number_Text,  x,Y,MidL,30,tTxt(#Str_Contactnumber)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Contact_Number_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Contact_Number_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Contact_Number,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Contact_Number,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Contact_Number,#PB_Gadget_BackColor,#WinCol_HomeScreen)

  Y + 40
  TextGadget(#Gad_Welcome_Group_Count_Text,     x,Y,MidL,30,tTxt(#Str_Groupcount)+":",#PB_Text_Right) :
  SetGadgetFont(#Gad_Welcome_Group_Count_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Group_Count_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Group_Count,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Group_Count,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Group_Count,#PB_Gadget_BackColor,#WinCol_HomeScreen)
 
  Y + 30
  TextGadget(#Gad_Welcome_Roll_Count_Text,      x,Y,MidL,30,tTxt(#Str_Rollcount)+":",#PB_Text_Right) :
  SetGadgetFont(#Gad_Welcome_Roll_Count_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Roll_Count_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Roll_Count,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Roll_Count,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Roll_Count,#PB_Gadget_BackColor,#WinCol_HomeScreen)

  Y + 30
  TextGadget(#Gad_Welcome_Rolls_Profiled14Days_Text,x,Y,MidL,30,tTxt(#Str_Profiledinlast14days)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Rolls_Profiled14Days_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Rolls_Profiled14Days_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Rolls_Profiled14Days,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Rolls_Profiled14Days,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Rolls_Profiled14Days,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  

  Y + 30
  TextGadget(#Gad_Welcome_Rolls_Profiled6Weeks_Text,x,Y,MidL,30,tTxt(#Str_Profiledinlast6weeks)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Rolls_Profiled6Weeks_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Rolls_Profiled6Weeks_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Rolls_Profiled6Weeks,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Rolls_Profiled6Weeks,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Rolls_Profiled6Weeks,#PB_Gadget_BackColor,#WinCol_HomeScreen)

  
  Y + 30
  TextGadget(#Gad_Welcome_Rolls_Profiled6Months_Text,x,Y,MidL,30,tTxt(#Str_Profiledinlast6months)+":",#PB_Text_Right)
  SetGadgetFont(#Gad_Welcome_Rolls_Profiled6Months_Text,FontID(#Font_List_L)) : SetGadgetColor(#Gad_Welcome_Rolls_Profiled6Months_Text,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  TextGadget(#Gad_Welcome_Rolls_Profiled6Months,x+Midr,Y,MidL,30,"")
  SetGadgetFont(#Gad_Welcome_Rolls_Profiled6Months,FontID(#Font_List_L_Bold)) : SetGadgetColor(#Gad_Welcome_Rolls_Profiled6Months,#PB_Gadget_BackColor,#WinCol_HomeScreen)
  
  ImageGadget(#Gad_Welcome_BorderRolls,X ,0,151,881,ImageID(#Image_BorderRolls)); : Y + 90

  Redraw_HomeScreen()
  
EndProcedure
Procedure Init_Window_RollInformation()
  Protected Y.i, SavedY.i, X.i = 310, Tmp.s
;  AddGadgetItem(#Gad_TabGadget,#Panel_Roll_Info,"Roll Information",ImageID(#Image_Info))
;  ContainerGadget(#Gad_Container_RollInfo, 0, 0, 716, 662, #PB_Container_Raised)

    Y = 6

    TextGadget(#Gad_Rollinfo_RollID_Text,X + 20,Y,118,16,tTxt(#Str_RollID)) :  SetGadgetColor(#Gad_Rollinfo_RollID_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_Rollinfo_Manufacturer_Text,X + 146,Y,118,16,tTxt(#Str_Manufacturer)) :  SetGadgetColor(#Gad_Rollinfo_Manufacturer_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_Rollinfo_DateMade_Text,X + 270,Y,90,16,tTxt(#Str_Datemade)) :  SetGadgetColor(#Gad_Rollinfo_DateMade_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_Rollinfo_Group_Text,X + 364,Y,90,16,tTxt(#Str_Group)) :  SetGadgetColor(#Gad_Rollinfo_Group_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_Rollinfo_Suitability_Text,X + 475,Y,120,16,tTxt(#Str_Suitability)) :  SetGadgetColor(#Gad_Rollinfo_Suitability_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    
    ButtonGadget(#Gad_RollInfo_Commit,X + 620,Y+2,90,20,tTxt(#Str_Commitchanges))
    ButtonGadget(#Gad_RollInfo_Undo,X + 620,Y+24,90,20,tTxt(#Str_Undochanges))

    Y + 17
    StringGadget(#Gad_Rollinfo_RollID_String,X + 20,Y,124,20,"",#PB_String_ReadOnly); :  setgadgetcolor(#Gad_Rollinfo_RollID_String,#PB_Gadget_BackColor,#WinCol_RollInfo)
    ComboBoxGadget(#Gad_Rollinfo_Manufacturer_String,X + 146,Y,120,20) ;:  setgadgetcolor(#Gad_Rollinfo_Manufacturer_String,#PB_Gadget_BackColor,#WinCol_RollInfo)
    ;AddGadgetItem(#Gad_Rollinfo_Manufacturer_String,-1,"*"+ tTxt(#Str_Unknown) +"*") ;/DNT
    ForEach ManufacturerList()
      AddGadgetItem(#Gad_Rollinfo_Manufacturer_String,-1,ManufacturerList()\Text)
    Next
    
    DateGadget(#Gad_Rollinfo_DateMade_Date,X + 270,Y,90,20); :  setgadgetcolor(#Gad_Rollinfo_DateMade_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    
    StringGadget(#Gad_Rollinfo_Group_Combo,X + 362,Y,110,20,"",#PB_String_ReadOnly) ; :  setgadgetcolor(#Gad_Rollinfo_Group_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    
    ComboBoxGadget(#Gad_Rollinfo_Suitability_String,X + 475,Y,140,20); :  setgadgetcolor(#Gad_Rollinfo_Suitability_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    Refresh_Suitability_List()
    ;AddGadgetItem(#Gad_Rollinfo_Suitability_String,-1,"*"+tTxt(#Str_Notset)+"*")
    ;ForEach SuitabilityList()
    ;  AddGadgetItem(#Gad_Rollinfo_Suitability_String,-1,SuitabilityList()\Text)
    ;Next

    Y + 28 : SavedY = Y

    ImageGadget(#Gad_RollInfo_Screen_Image,X + 16,Y,ImageWidth(#Image_RollInfo_Screen),ImageHeight(#Image_RollInfo_Screen),ImageID(#Image_RollInfo_Screen))
    ImageGadget(#Gad_RollInfo_Wall_Image,X + 96,Y,ImageWidth(#Image_RollInfo_Wall),ImageHeight(#Image_RollInfo_Wall),ImageID(#Image_RollInfo_Wall))
    ImageGadget(#Gad_RollInfo_Opening_Image,X + 176,Y,ImageWidth(#Image_RollInfo_Opening),ImageHeight(#Image_RollInfo_Opening),ImageID(#Image_RollInfo_Opening))
    
    Y + 22
    StringGadget(#Gad_RollInfo_Screen_String,X + 20,Y,40,18,"")
    StringGadget(#Gad_RollInfo_Wall_String,X + 100,Y,40,18,"")
    StringGadget(#Gad_RollInfo_Opening_String,X + 180,Y,40,18,"")
    StringGadget(#Gad_RollInfo_Width_String,X + 260,Y,40,18,"")
    
    TextGadget(#Gad_RollInfo_Screen_UnitText,X + 62,Y,20,20,System\Settings_Screen_UnitMask) :  SetGadgetColor(#Gad_RollInfo_Screen_UnitText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Wall_UnitText,X + 142,Y,20,20,System\Settings_Length_UnitMask) :  SetGadgetColor(#Gad_RollInfo_Wall_UnitText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Opening_UnitText,X + 222,Y,20,20,System\Settings_Length_UnitMask) :  SetGadgetColor(#Gad_RollInfo_Opening_UnitText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Width_UnitText,X + 302,Y,22,20,System\Settings_MLength_UnitMask) :  SetGadgetColor(#Gad_RollInfo_Width_UnitText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    Y + 20
    TextGadget(#Gad_RollInfo_Screen_IDText,X + 20,Y,80,20,tTxt(#Str_Screen))    :  SetGadgetColor(#Gad_RollInfo_Screen_IDText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Wall_IDText,X + 100,Y,80,40,tTxt(#Str_Wallwidth)) :  SetGadgetColor(#Gad_RollInfo_Wall_IDText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Opening_IDText,X + 180,Y,80,40,tTxt(#Str_Cellopening)) :  SetGadgetColor(#Gad_RollInfo_Opening_IDText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Width_IDText,X + 260,Y,70,40,tTxt(#Str_Rollwidth)) :  SetGadgetColor(#Gad_RollInfo_Width_IDText,#PB_Gadget_BackColor,#WinCol_RollInfo)
    
    Y + 18
    TextGadget(#Gad_RollInfo_GeneralHistory_History_Text,X + 20,Y,180,18,tTxt(#Str_Generalhistory)+":") : SetGadgetColor(#Gad_RollInfo_GeneralHistory_History_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    
    Y + 18

    ListIconGadget(#Gad_RollInfo_GeneralHistory_History_List,X + 20,Y,600,90,tTxt(#Str_Date),80,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
    AddGadgetColumn(#Gad_RollInfo_GeneralHistory_History_List,1,tTxt(#Str_Type),100)
    AddGadgetColumn(#Gad_RollInfo_GeneralHistory_History_List,2,tTxt(#Str_Comments),390)

    SendMessage_(GadgetID(#Gad_RollInfo_GeneralHistory_History_List), #LVM_SETEXTENDEDLISTVIEWSTYLE, 0, #LVS_EX_LABELTIP|#LVS_EX_FULLROWSELECT) 
;    SendMessage_(GadgetID(#Gad_RollInfo_GeneralHistory_History_List), #LVM_SETEXTENDEDLISTVIEWSTYLE, #LVS_EX_FULLROWSELECT, #LVS_EX_FULLROWSELECT)
    
    Y = SavedY
    TextGadget(#Gad_RollInfo_Comment_Text,X + 330,Y+2,80,18,tTxt(#Str_Comments)+":") :  SetGadgetColor(#Gad_RollInfo_Comment_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    Y = SavedY + 20
    EditorGadget(#Gad_RollInfo_Comment_Box,X + 330,Y,290,38)
    SetGadgetFont(#Gad_RollInfo_Comment_Box,FontID(#Font_List_S))
    ;Debug "Original FonID: "+Str(#Font_List_M)
    
    Y + 154
    TextGadget(#Gad_RollInfo_Image_Reference_Text,X + 80,Y,240,18,tTxt(#Str_Reference)+":") :  SetGadgetColor(#Gad_RollInfo_Image_Reference_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    TextGadget(#Gad_RollInfo_Image_Latest_Text,X + 370,Y,200,18,tTxt(#Str_Lastimported)+" / "+tTxt(#Str_selected)+":") : SetGadgetColor(#Gad_RollInfo_Image_Latest_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    ImageGadget(#Gad_RollInfo_Image_Reference,X + 80,Y+18,240,180,0,#PB_Image_Border)
    ImageGadget(#Gad_RollInfo_Image_Latest,X + 370,Y+18,240,180,0,#PB_Image_Border)

    Y + 210
    
    ImageGadget(#Gad_RollInfo_AniCAM_Image,X + 10,Y,ImageWidth(#Image_AniCAM),ImageHeight(#Image_AniCAM),ImageID(#Image_AniCAM))
    
    ImageGadget(#Gad_RollInfo_Roll_Image,X + 174,Y+16,ImageWidth(#Image_Roll_Large),ImageHeight(#Image_Roll_Large),ImageID(#Image_Roll_Large))
    DisableGadget(#Gad_RollInfo_Roll_Image,1)
    ImageGadget(#Gad_RollInfo_Roll_Pins,X + 174,Y+80+41,ImageWidth(#Image_Roll_Pins),ImageHeight(#Image_Roll_Pins),ImageID(#Image_Roll_Pins))
    DisableGadget(#Gad_RollInfo_Roll_Pins,1)
    
    TextGadget(#Gad_Rollinfo_Readings_Text,X+75,Y+36,100,30,tTxt(#Str_Readings),#PB_Text_Center) : SetGadgetColor(#Gad_Rollinfo_Readings_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    SetGadgetFont(#Gad_Rollinfo_Readings_Text,FontID(#Font_List_L))

    Y + 80
    
    TextGadget(#Gad_RollInfo_Original_Text,X-10 ,Y+20,62,20,tTxt(#Str_Reference)+":",#PB_Text_Right):  SetGadgetColor(#Gad_RollInfo_Original_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    ListIconGadget(#Gad_RollInfo_Original_List,X + 60,Y-4,580,48,tTxt(#Str_Date)+":",66,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#LVS_NOCOLUMNHEADER)
;    ListIconGadget(#Gad_RollInfo_Original_List,X + 60,Y-4,580,48,tTxt(#Str_Date)+":",80,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
;SetListIconColumnJustification(#Gad_RollInfo_Original_List,0,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,1,tTxt(#Str_Examiner),70)
    AddGadgetColumn(#Gad_RollInfo_Original_List,2,"1",38)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,2,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,3,"2",38)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,3,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,4,"3",38)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,4,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,5,"4",38)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,5,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,6,"5",38)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,6,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,7,":",18)
    AddGadgetColumn(#Gad_RollInfo_Original_List,8,"cm3/m2",50) ;/DNT
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,8,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,9,tTxt(#Str_Variance),58)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,9,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_Original_List,10,tTxt(#Str_Capacity),58)
    SetListIconColumnJustification(#Gad_RollInfo_Original_List,10,#PB_ListIcon_JustifyColumnCenter)
    ;MessageRequester("Show Depth: "+Str(System\Show_Depth),",")
    
    If System\Show_Depth = 1
      AddGadgetColumn(#Gad_RollInfo_Original_List,11,"Depth",46);tTxt(#Str_Depth),60)
      SetListIconColumnJustification(#Gad_RollInfo_Original_List,11,#PB_ListIcon_JustifyColumnCenter)
    EndIf

 ;    SetGadgetItemColor(#Gad_RollInfo_Original_List,-1,#PB_Gadget_BackColor,RGB(250,200,200),4)
;    SetGadgetItemColor(#Gad_RollInfo_Original_List,-1,#PB_Gadget_BackColor,RGB(250,200,200),6)
    
    ;AddGadgetItem(#Gad_RollInfo_Original_List,-1,tTxt(#Str_Test))
    SendMessage_(GadgetID(#Gad_RollInfo_Original_List), #LVM_SETEXTENDEDLISTVIEWSTYLE, 0, #LVS_EX_LABELTIP|#LVS_EX_FULLROWSELECT) 

    ;    SetGadgetItemColor(#Gad_RollInfo_Original_List,0,#PB_Gadget_BackColor,RGB(0,255,0),9)

    Y + 50
    TextGadget(#Gad_RollInfo_History_Text,X-10 ,Y,62,20,tTxt(#Str_Historical)+":",#PB_Text_Right)
    SetGadgetColor(#Gad_RollInfo_History_Text,#PB_Gadget_BackColor,#WinCol_RollInfo)
    ListIconGadget(#Gad_RollInfo_History_List,X + 60,Y,580,100,tTxt(#Str_Date),66,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines|#LVS_NOCOLUMNHEADER|#PB_ListIcon_AlwaysShowSelection)
    AddGadgetColumn(#Gad_RollInfo_History_List,1,tTxt(#Str_Examiner),70)
    AddGadgetColumn(#Gad_RollInfo_History_List,2,"1",38)
    SetListIconColumnJustification(#Gad_RollInfo_History_List,2,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,3,"2",38)
    SetListIconColumnJustification(#Gad_RollInfo_History_List,3,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,4,"3",38)
    SetListIconColumnJustification(#Gad_RollInfo_History_List,4,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,5,"4",38)
    SetListIconColumnJustification(#Gad_RollInfo_History_List,5,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,6,"5",38)
    SetListIconColumnJustification(#Gad_RollInfo_History_List,6,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,7,"=",18)
    AddGadgetColumn(#Gad_RollInfo_History_List,8,"cm3/m2",50) ;/DNT
    SetListIconColumnJustification(#Gad_RollInfo_History_List,8,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,9,tTxt(#Str_Variance),58) 
    SetListIconColumnJustification(#Gad_RollInfo_History_List,9,#PB_ListIcon_JustifyColumnCenter)
    AddGadgetColumn(#Gad_RollInfo_History_List,10,tTxt(#Str_Capacity),58)
    SetListIconColumnJustification(#Gad_RollInfo_History_List,10,#PB_ListIcon_JustifyColumnCenter)
    If System\Show_Depth = 1
      AddGadgetColumn(#Gad_RollInfo_History_List,11,tTxt(#Str_Depth),46)
      SetListIconColumnJustification(#Gad_RollInfo_History_List,11,#PB_ListIcon_JustifyColumnCenter)
    EndIf
    
    
    SendMessage_(GadgetID(#Gad_RollInfo_History_List), #LVM_SETEXTENDEDLISTVIEWSTYLE, 0, #LVS_EX_LABELTIP|#LVS_EX_FULLROWSELECT) 
    Y-100
    ;    Framegadget(#Gad_RollInfo_Import_Frame,600,Y,100,90,"Import options") : Y + 20
    Tmp.s = ":"+" "+tTxt(#Str_AMS)
    ButtonGadget(#Gad_RollInfo_Import_New,x+500,y,24,20,"+")
    GadgetToolTip(#Gad_RollInfo_Import_New,tTxt(#Str_Insertnewreading))
    ButtonGadget(#Gad_RollInfo_Import_AMS,X + 550,Y,80,20,tTxt(#Str_Import)+Tmp)       : Y + 20
    Tmp.s = ":"+" "+tTxt(#Str_ACP)
;    ButtonGadget(#Gad_RollInfo_Import_ACP,X + 550,Y,80,20,tTxt(#Str_Import)+Tmp)       : Y + 22
;    DisableGadget(#Gad_RollInfo_Import_ACP,1)
;    ButtonGadget(#Gad_RollInfo_Import_New,X + 610,Y,80,18,"Manual Entry")       : Y + 40
;    ButtonGadget(#Gad_RollInfo_Edit,X + 600,Y,90,18,"Edit Selected")           : Y + 20
;    ButtonGadget(#Gad_RollInfo_Delete,X + 600,Y,90,18,"Delete Selected")       : Y + 20
    
    ;SetGadgetColor(#Gad_RollInfo_Import_AMS,#PB_Gadget_BackColor,RGB(80,220,80))
    
;  #Gad_RollInfo_Import_AMS
;  #Gad_RollInfo_Import_ACP
;  #Gad_RollInfo_Import_New ;Manually input values
;  #Gad_RollInfo_Delete
;  #Gad_RollInfo_Edit


;  CloseGadgetList()
;  SetGadgetColor(#Gad_Container_RollInfo,#PB_Gadget_BackColor,#WinCol_RollInfo)
EndProcedure
Procedure Init_Window_Reporting()
  Protected X.i = 296, Y = 14
  ; Huge potential!
  ; Filter:
  ; --------
  ; SiteList - 0 = all - ComboBox
  ; Manufacturer - Combo - 0 = all
  ; LPI - From - To
  ; Vol - From - To
  ; Capacity - From - To
  ; Variance - From - To
  ; LastReadingDate.
  ; Suitability - Combo
  ; 
  ; Preset:
  ; --------
  ; Preset ComboBox
  ; Save Preset Button
  ; 
  ; Filter Logic:
  ; Equal To			            =
  ; Less than			            <
  ; Greater than			        >
  ; Less than Or Equal To		  <=
  ; Greater than Or equal To	>=
  ; Not Equal To			        <>
  ; Between				            Between
  ; 
  ;/ to be populated with Report Preset Database *!*
  
  FrameGadget(#Gad_Report_Filter_Frame,x,2,720,64,"")
  
  TextGadget(#Gad_Report_Preset_Combo_Text,X+2,Y+4,94,20,tTxt(#Str_Selectreport)+":",#PB_Text_Right)
  SetGadgetColor(#Gad_Report_Preset_Combo_Text,#PB_Gadget_BackColor,#WinCol_Report)
  ComboBoxGadget(#Gad_Report_Preset_Combo,x+104,y,340,20)
  
  ClearGadgetItems(#Gad_Report_Preset_Combo)
  Refresh_Presets_List()
  SetGadgetState(#Gad_Report_Preset_Combo,0)
  
  ButtonGadget(#Gad_Report_New,x+450,y,60,20,tTxt(#Str_New))
  ButtonGadget(#Gad_Report_Edit,x+514,y,60,20,tTxt(#Str_Edit))
  ButtonGadget(#Gad_Report_Delete,x+578,y,60,20,tTxt(#Str_Delete))
  y+24
  
;  ButtonGadget(#Gad_Report_ExportPDF,x+610, 4,110,20,"Export view to PDF")
;  ButtonGadget(#Gad_Report_ExportXLS,x+610,26,110,20,"Export view to XLS")
;  ButtonGadget(#Gad_Report_ExportCSV,x+610,48,110,20,"Export view to CSV")
 
  TextGadget(#Gad_Report_SortBy_Combo_Text,X+2,Y+4,94,20,tTxt(#Str_Sortby)+":",#PB_Text_Right)
  SetGadgetColor(#Gad_Report_SortBy_Combo_Text,#PB_Gadget_BackColor,#WinCol_Report)
  
  ComboBoxGadget(#Gad_Report_SortBy_Combo,x+104,y,112,20)

  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_RollID,tTxt(#Str_RollID))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_Manufacturer,tTxt(#Str_Manufacturer))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_Screen,tTxt(#Str_Screen))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_Volume,tTxt(#Str_Volume))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_Variance,tTxt(#Str_Variance))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_Capacity,tTxt(#Str_Capacity))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_Suitability,tTxt(#Str_Suitability))
  AddGadgetItem(#Gad_Report_SortBy_Combo,#Report_Sort_ReadingDate,tTxt(#Str_Readingdate))
  SetGadgetState(#Gad_Report_SortBy_Combo,0)
  
  TextGadget(#Gad_Report_SortDirection_Text,X+222,Y+4,50,20,tTxt(#Str_Direction)+":")
  SetGadgetColor(#Gad_Report_SortDirection_Text,#PB_Gadget_BackColor,#WinCol_Report)
  ComboBoxGadget(#Gad_Report_SortDirection_Combo,x+272,y,120,20)
  AddGadgetItem(#Gad_Report_SortDirection_Combo,-1,tTxt(#Str_Ascending))
  AddGadgetItem(#Gad_Report_SortDirection_Combo,-1,tTxt(#Str_Descending))
  SetGadgetState(#Gad_Report_SortDirection_Combo,0)
  
  TextGadget(#Gad_Report_Style_Text,x+400,y+4,50,20,tTxt(#Str_Style)+":")
  SetGadgetColor(#Gad_Report_Style_Text,#PB_Gadget_BackColor,#WinCol_Report)
  ComboBoxGadget(#Gad_Report_Style_Combo,x+450,y,100,20)
  AddGadgetItem(#Gad_Report_Style_Combo,-1,tTxt(#Str_Grouped))
  AddGadgetItem(#Gad_Report_Style_Combo,-1,tTxt(#Str_Flat))
  SetGadgetState(#Gad_Report_Style_Combo,0)

  TextGadget(#Gad_Report_Counts_Text,X+554,Y+4,134,20,"")
  SetGadgetColor(#Gad_Report_Counts_Text,#PB_Gadget_BackColor,#WinCol_Report)

  y+40
  ListIconGadget(#Gad_Report_ReportList,X,y,720,590,"",100,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect);_|#LVS_NOCOLUMNHEADER)
  ;    SetGadgetFont(#Gad_Report_ReportList,#Font_List_M)
  AddGadgetColumn(#Gad_Report_ReportList,1,"",90)
  AddGadgetColumn(#Gad_Report_ReportList,2,"",40)
  AddGadgetColumn(#Gad_Report_ReportList,3,"",60)
  AddGadgetColumn(#Gad_Report_ReportList,4,"",60)
  AddGadgetColumn(#Gad_Report_ReportList,5,"",60)
  AddGadgetColumn(#Gad_Report_ReportList,6,"",100)
  AddGadgetColumn(#Gad_Report_ReportList,7,"",80)
  AddGadgetColumn(#Gad_Report_ReportList,8,"",100)
  SendMessage_(GadgetID(#Gad_Report_ReportList), #LVM_SETEXTENDEDLISTVIEWSTYLE, 0, #LVS_EX_LABELTIP|#LVS_EX_FULLROWSELECT) 

EndProcedure
Procedure Init_Window_2DAnalysis()
  Protected X.i = 290
  ;  AddGadgetItem(#Gad_TabGadget,#Panel_2D_View,"2D View",ImageID(#Image_TreeView_Group))
  CreateImage(#Image_2d_Scaled,64,64)
  ImageGadget(#Gad_2D_Analysis_Image,X + 42,20,640,480,0,#PB_Image_Border)
  ImageGadget(#Gad_2D_Analysis_Image_Mag,X + 42,510,64,64,0,#PB_Image_Border)
  
  
  ; ContainerGadget(#Gad_Container_Group, 0, 0, 718, 666, #PB_Container_Raised)
  ; CloseGadgetList()
  ; SetGadgetColor(#Gad_Container_Group,#PB_Gadget_BackColor,#WinCol_Report)
EndProcedure
Procedure Init_Window_3DAnalysis()
  Protected X.i = 290
;  AddGadgetItem(#Gad_TabGadget,#Panel_3d_View,"3D View",ImageID(#Image_TreeView_Group))
  ImageGadget(#Gad_3D_Analysis_Image,X + 10,10,640,480,0,#PB_Image_Border)
  ; ContainerGadget(#Gad_Container_Group, 0, 0, 718, 666, #PB_Container_Raised)
  ; CloseGadgetList()
  ; SetGadgetColor(#Gad_Container_Group,#PB_Gadget_BackColor,#WinCol_Report)
EndProcedure

Procedure Init_Images()
  Protected Scale.f
  
  CatchImage(#Image_Splash,?Splash)
  CatchImage(#Image_Logo,?Logo)

  CatchImage(#Image_Logo_Opaque,?Logo_Opaque)
  CatchImage(#Image_TreeView_Plant,?Chart)
  CatchImage(#Image_TreeView_Group,?Group2)
  CatchImage(#Image_Roll,?SmallRoll)
  CatchImage(#Image_Roll_Large,?Roll)
  CatchImage(#Image_Roll_Pins,?Roll_Pins)
  CatchImage(#Image_TreeView_Home,?home)
;  CatchImage(#Image_Info,?Info)
  CatchImage(#Image_Treeview_Factory,?Factory2)
  CatchImage(#Image_Star,?star)
  CatchImage(#Image_RollInfo_Opening,?Roll_Opening)
  CatchImage(#Image_RollInfo_Screen,?Roll_Screen)
  CatchImage(#Image_RollInfo_Wall,?Roll_Wall)
  ;  CatchImage(#Image_RollInfo_Sample,?Sample)
  CatchImage(#Image_AniCAM,?AniCAM)
  CatchImage(#Image_AniCAM_Opaque,?AniCAM_Opaque)
  CatchImage(#NoImageLoaded,?NoImageLoaded)
  CatchImage(#Image_AniCAMIcon,?AniCAMIcon)
  
  CatchImage(#Image_Export_XLS,?Icon_XLS)
  CatchImage(#Image_Export_CSV,?Icon_CSV)
  CatchImage(#Image_Export_PDF,?Icon_PDF)
  CatchImage(#Image_Export_IMG,?Icon_IMG)
  CatchImage(#Image_AutoImport,?Icon_AutoImport)

  CatchImage(#Image_RollInfo_Opening_Opaque,?Roll_Opening_Opaque)
  CatchImage(#Image_RollInfo_Screen_Opaque,?Roll_Screen_Opaque)
  CatchImage(#Image_RollInfo_Wall_Opaque,?Roll_Wall_Opaque)
  CatchImage(#Image_RollInfo_Roll_Opaque,?Roll_Opaque)
  CatchImage(#Image_RollInfo_Roll_Pins_Opaque,?Roll_Pins_Opaque)
  
  CatchImage(#Image_BorderRolls,?BorderRolls)
  CatchImage(#Image_TroikaAMS,?TroikaAMS)
  
  CatchImage(#Image_Padlock_Open,?Padlock_Open)
  CatchImage(#Image_Padlock_Closed,?Padlock_Closed)
  CatchImage(#Image_PrinterIcon,?Print_Start)
  
  CopyImage(#Image_BorderRolls,#Image_BorderRolls_Scaled)
  CreateImage(#Image_2d_Image_Current,32,32)
  CreateImage(#Image_2d_Image_Reference,32,32)
  
  CopyImage(#Image_2d_Image_Current ,#Image_RollInfo_Current_Scaled)
  CopyImage(#Image_2d_Image_Reference,#Image_RollInfo_Referencel_Scaled)
  CopyImage(#Image_Roll_Large,#Image_Roll_Large_Scaled)
  CopyImage(#Image_Roll_Pins,#Image_Roll_Pins_Scaled)
  CopyImage(#Image_Logo,#Image_Logo_Scaled)
  CopyImage(#Image_TroikaAMS,#Image_TroikaAMS_Scaled)
  
  ;/ New - Nov 2012
  
  CopyImage(#Image_Logo,#Image_OEM_Logo)
  
;  If FileSize("OEM\OEM Logo.bmp") > -1
;    LoadImage(#Image_OEM_Logo,"OEM\OEM Logo.jpg")
;  EndIf
  If FileSize("OEM\OEM Logo.jpg") > -1
    LoadImage(#Image_OEM_Logo,"OEM\OEM Logo.jpg")
  EndIf
  If FileSize("OEM\OEM Logo.png") > -1
    LoadImage(#Image_OEM_Logo,"OEM\OEM Logo.png")
  EndIf

  ResizeImage(#Image_OEM_Logo,260,94)
  
  System\OEMLogo.s = "OEM\OEM Logo PDF.jpg" ;/ have to ensure the PDF image doesn't have any alpha channel (saving as JPG does that).
  SaveImage(#Image_OEM_Logo,"OEM\OEM Logo PDF.jpg",#PB_ImagePlugin_JPEG)
  
  System\Weblink = "WWW.Troika-Systems.com"
  
  If FileSize("OEM\OEM Weblink.txt") > -1
    If OpenFile(1,"OEM\OEM Weblink.txt")
      System\Weblink = ReadString(1)
      CloseFile(1)
    EndIf
  EndIf
  
EndProcedure
Procedure Init_Window_Main()
  Protected SiteLoop.i, Loop1.i, Loop2.i, X.i = 294, Y.i

  OpenWindow(#Window_Main,0,0,WinInfo\WinXMin,WinInfo\WinYMin,"Troika Systems - AMS"+Program_Version,#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible) ;/DNT
  
  ContainerGadget(#Gad_LHS_Container,0,0,290,WinInfo\WinYMin-20,#PB_Container_Raised)

  Y = 0
  
  ButtonImageGadget(#Gad_TroikaButton,2,y,280,94,ImageID(#Image_OEM_Logo)) : Y + 96
  
  FrameGadget(#Gad_SearchBox_Frame,2,Y,280,32,"") : Y + 10
  TextGadget(#Gad_SearchBoxText,6,y,80,18,tTxt(#Str_Searchstring)+":") 
  StringGadget(#Gad_SearchBox,80,y-2,80,20,"") 
  ButtonGadget(#Gad_SearchPrevious,162,y-2,58,20,tTxt(#Str_Previous)) 
  ButtonGadget(#Gad_SearchNext,220,y-2,58,20,tTxt(#Str_Next)) 
  
  Y + 24
  
  TreeGadget(#Gad_NavTree,2,Y,280,WinInfo\WinYMin-(Y+60),#PB_Tree_AlwaysShowSelection)
  SetGadgetFont(#Gad_NavTree, FontID(#Font_List_M))
  EnableGadgetDrop(#Gad_NavTree, #PB_Drop_Private, #PB_Drag_Move, 0)
  
  Y = WinInfo\WinYMin-58
  
  ButtonImageGadget(#Gad_Icon_Export_CSV,2,y,32,32,ImageID(#Image_Export_CSV))
  GadgetToolTip(#Gad_Icon_Export_CSV,tTxt(#Str_ExporttoCSV))
  ButtonImageGadget(#Gad_Icon_Export_XLS,34,y,32,32,ImageID(#Image_Export_XLS))
  GadgetToolTip(#Gad_Icon_Export_XLS,tTxt(#Str_ExporttoExcel)+"("+tTxt(#Str_MicrosoftExcelrequired)+")")
  ButtonImageGadget(#Gad_Icon_Export_PDF,66,y,32,32,ImageID(#Image_Export_PDF))
  GadgetToolTip(#Gad_Icon_Export_PDF,tTxt(#Str_ExporttoPDF))
  ButtonImageGadget(#Gad_Icon_Export_IMG,98,y,32,32,ImageID(#Image_Export_IMG))
  GadgetToolTip(#Gad_Icon_Export_IMG,tTxt(#Str_Exportscreentoclipboard)+", "+tTxt(#Str_emailorfile))
  ButtonImageGadget(#Gad_Icon_Export_Print,130,y,32,32,ImageID(#Image_PrinterIcon))
  GadgetToolTip(#Gad_Icon_Export_Print,"Print")
  
  ButtonImageGadget(#Gad_AutoImport,162,y,46,32,ImageID(#Image_AutoImport),#PB_Button_Toggle)
  
  If System\LiveMonitor = 0
    GadgetToolTip(#Gad_AutoImport,tTxt(#Str_Toggleautomaticimporting)+":"+" "+tTxt(#Str_CurrentlyOff))
  Else
    GadgetToolTip(#Gad_AutoImport,tTxt(#Str_Toggleautomaticimporting)+":"+" "+tTxt(#Str_CurrentlyOn))
  EndIf
  
  SetGadgetState(#Gad_AutoImport,System\LiveMonitor)
  
  ButtonImageGadget(#Gad_Icon_Manager_Mode,240,Y,42,32,ImageID(#Image_Padlock_Closed))
  GadgetToolTip(#Gad_Icon_Manager_Mode,tTxt(#Str_ManagerMode)+":"+" "+tTxt(#Str_CurrentlyOff))
  

  CloseGadgetList() ;/ end of container section

  ;- Panel Gadget - Home Screen / Welcome
  ;- PanelGadget(#Gad_TabGadget,290,30,System\Desktop_Width-298,System\Desktop_Height-76)
  
  Init_Window_HomeScreen()
  
  ;- Panel Gadget - Roll / Group List -> Multi reporting tool
  
  Init_Window_Reporting()

  ;- Panel Gadget - Roll Information
  
  Init_Window_RollInformation()
  
  Init_Window_2DAnalysis()
  
  Init_Window_3DAnalysis()
;  If #Debug
    Y = 30

    EditorGadget(#Gad_SQL_Query_Txt,X + 3, Y + 4,712,200)
    
    ComboBoxGadget(#Gad_SQL_Dropdown,X + 3, Y + 210,180,20)
    ForEach My_SQL_Queries()
      AddGadgetItem(#Gad_SQL_Dropdown,-1,My_SQL_Queries()\Title)
    Next
    SetGadgetState(#Gad_SQL_Dropdown,0)
    
    ButtonGadget(#Gad_SQL_Set,X + 190, Y + 210,50,20,tTxt(#Str_Set))
    ButtonGadget(#Gad_SQL_Run,X + 244, Y + 210,50,20,tTxt(#Str_Run))
    ButtonGadget(#Gad_SQL_Clear,X + 298, Y + 210,50,20,tTxt(#Str_Clear))
    ComboBoxGadget(#Gad_SQL_QueryUpdateCombo,x+400,Y+210,120,20)
    AddGadgetItem(#Gad_SQL_QueryUpdateCombo,-1,"SQL Query")
    AddGadgetItem(#Gad_SQL_QueryUpdateCombo,-1,"SQL Update")
    SetGadgetState(#Gad_SQL_QueryUpdateCombo,0)
    
    ListIconGadget(#Gad_SQL_Result_Txt,X + 3, Y + 240,712,396,"**",700)
    
;/ Debug panel 
    ListViewGadget(#Gad_MessageList,X , 2 ,718,666)
    

  Init_Menu()

  SetWindowCallback(@Window_Callback(),#Window_Main)

  Flush_Events()
  
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Control|#PB_Shortcut_R,#Menu_Force_Refresh)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Shift|#PB_Shortcut_Up,#Menu_Navigate_LineUp)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Shift|#PB_Shortcut_Down,#Menu_Navigate_LineDown)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Delete|#PB_Shortcut_Shift,#Menu_Keystroke_Delete)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Control|#PB_Shortcut_Alt|#PB_Shortcut_Shift|#PB_Shortcut_S,#Menu_Keystroke_SQL)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Control|#PB_Shortcut_Alt|#PB_Shortcut_Shift|#PB_Shortcut_O,#Menu_Keystroke_Export)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Control|#PB_Shortcut_Alt|#PB_Shortcut_Shift|#PB_Shortcut_I,#Menu_Keystroke_Import)
  
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Control|#PB_Shortcut_Alt|#PB_Shortcut_Shift|#PB_Shortcut_D,#Menu_Keystroke_Debug)
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Control|#PB_Shortcut_I,#Menu_ShortCut_Master_Import) ;/*CHG*
  Flush_Events()
;  HideWindow(#Window_Main,0)
EndProcedure 

Procedure Init_Begin()
  Init_Fonts()
  Init_Images()
  
  If #Debug = 0 : DisplaySplash(#Image_Splash,3000) : EndIf
  
  Init_EULA()
  
  ExamineDesktops()
  System\Desktop_Width = DesktopWidth(0)
  System\Desktop_Height = DesktopHeight(0)
  WinInfo\WinXMin = 1024 : WinInfo\WinYMin = 690
  Debug WinInfo\WinXMin
  Debug WinInfo\WinYMin  

EndProcedure
Procedure Init_End()
  AssignScaleToAll()
  HideWindow(#Window_Main,0)
EndProcedure

Procedure Program_End()
  CloseDatabase(1)
  End
EndProcedure
Procedure Init_Test()
  ;/ Procedure to test for redraw times & memory leak on RollID refresh routine
  Protected Timer.i, CurrentRollID.i, RollCount.i, Text.s, TempTime.i, BestTime.i, WorstTime.i, MyLoop.i, Loops.i
  Flush_Events()
  SendMessage_(WindowID(#Window_Main),#WM_SETREDRAW,#False,0)
  Loops.i = 100
  RollCount = 0
  
  CurrentRollID = System\Selected_Roll_ID
  
  System\Selected_Roll_ID = -1
  BestTime = 99999
  Timer = ElapsedMilliseconds()
  For MyLoop = 1 To Loops
    TempTime = ElapsedMilliseconds()
    ForEach NavTree()
      If Navtree()\RollID <> 0
        RollCount + 1
        Redraw_RollID(Navtree()\RollID)
      EndIf
    Next
    TempTime = ElapsedMilliseconds() - TempTime
    If TempTime < BestTime : BestTime = TempTime : EndIf
    If TempTime > WorstTime : WorstTime = TempTime : EndIf
    Flush_Events()
  Next
  
  SendMessage_(WindowID(#Window_Main),#WM_SETREDRAW,#True,0)
  
  Timer = ElapsedMilliseconds() - Timer

  Redraw_RollID(CurrentRollID)
  
  Text = "Number of test loops: "+Str(Loops) + Chr(10) ;/DNT
  Text + "Extracted and redrew "+Str(RollCount)+" rolls in: "+Str(timer)+"ms"+Chr(10) ;/DNT
  Text + Str(timer/RollCount)+"ms per roll"+ Chr(10) + "Worst Time for loop: "+Str(WorstTime)+"ms"+Chr(10)+"Best Time for loop: "+Str(BestTime)+"ms" ;/DNT
  Text +Chr(10) + "Number of database writes "+Str(System\DatabaseWrites) ;/DNT
  MessageRequester("Message:",Text,#PB_MessageRequester_Ok) ;/DNT
  
EndProcedure

Procedure Set_NavTree_Position(Pos.i)
  If Pos < 0 Or Pos > ListSize(NavTree())-1 : ProcedureReturn : EndIf
  Debug "Position: "+Str(Pos)
  SetGadgetState(#Gad_NavTree,Pos)
  System\TV_Line = GetGadgetState(#Gad_NavTree)
  SelectElement(NavTree(),Pos)
  
  If NavTree()\Type = #NavTree_Company
    Redraw_HomeScreen()
    Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
  EndIf
  
  If NavTree()\Type = #NavTree_Site
    System\Last_Drawn_Report_SiteID = NavTree()\SiteID
    System\Last_Drawn_Report_GroupID = -1
    System\Selected_Site = NavTree()\SiteID
    Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
    Show_Window(#Panel_Group_List,#PB_Compiler_Line)

  EndIf
  
  If NavTree()\Type = #NavTree_Group
    System\Last_Drawn_Report_SiteID = NavTree()\SiteID
    System\Last_Drawn_Report_GroupID = NavTree()\GroupID
    System\Selected_Group = NavTree()\GroupID
    System\Selected_Site = NavTree()\SiteID
    Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
    Show_Window(#Panel_Group_List,#PB_Compiler_Line)

  EndIf
  
  If NavTree()\Type = #NavTree_Roll
    Redraw_RollID(NavTree()\RollID,1)
    System\Selected_Roll_ID_Text =  NavTree()\String
    System\Selected_Roll_ID = NavTree()\RollID
    System\Selected_Group = NavTree()\GroupID
    System\Selected_Site = NavTree()\SiteID    
    Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
    
  EndIf
EndProcedure

Procedure Process_Menu_Events() ;/*CHG*
  Protected Result.S, Code.S, Queryi.i, Resulti.i, Position.i, Group.i, RollID.i, OnTreePos.i, MyLoop.i, Found.i
  Select EventMenu() ; get the clicked menu item...
    Case #Menu_Keystroke_Delete
      ;/ This triggers other menu messages based on whereabouts the action took place
      Select System\LastSelectedGadget
        Case #Gad_NavTree
          SelectElement(NavTree(),GetGadgetState(#Gad_Navtree))
          Select NavTree()\Type
            Case #NavTree_Roll
              PostMessage_(WindowID(#Window_Main), #WM_COMMAND, #Menu_Popup3_Roll_Delete, 0)
            Case #NavTree_Group
              PostMessage_(WindowID(#Window_Main), #WM_COMMAND, #Menu_Popup2_Group_Delete, 0)
          EndSelect
        Case #Gad_RollInfo_History_List
          PostMessage_(WindowID(#Window_Main), #WM_COMMAND, #Menu_Popup7_Historical_Reading_Delete, 0)
          
      EndSelect
      
    Case #Menu_Keystroke_Debug
      Show_Window(#Panel_Debug,#PB_Compiler_Line) 
    Case #Menu_Keystroke_SQL
      Show_Window(#Panel_SQL,#PB_Compiler_Line) 
    Case #Menu_Keystroke_Export
      Debug "Calling Export Roll: "+Str(System\Selected_Roll_ID)
      If System\Selected_Roll_ID > 0
        
        Database_ExportRoll(System\Selected_Roll_ID)
        
      EndIf
    Case #Menu_Keystroke_Import
      Database_ImportRoll(System\Selected_Site, System\Selected_Group)
      
    Case #Menu_Navigate_LineUp
      Select System\LastSelectedGadget
        Case #Gad_NavTree
          Debug "Line Up"
          OnTreePos = GetGadgetState(#Gad_NavTree)
          If OnTreePos > 0
            OnTreePos - 1
          Else
            OnTreePos = ListSize(Navtree())-1
          EndIf
          Set_NavTree_Position(OnTreePos)
        Case #Gad_RollInfo_History_List
          If ListSize(HistoryList()) > 0
          OnTreePos = GetGadgetState(#Gad_RollInfo_History_List)
          If OnTreePos > 0
            OnTreePos - 1
          Else
            OnTreePos = ListSize(HistoryList())-1
          EndIf
          SetGadgetState(#Gad_RollInfo_History_List,OnTreePos)          
          SelectElement(HistoryList(),OnTreePos)
          System\Selected_HistoryID = HistoryList()
          Image_Refresh_History(System\Selected_HistoryID)
        EndIf
        
      EndSelect  
    Case #Menu_Navigate_LineDown
      Select System\LastSelectedGadget
        Case #Gad_NavTree
          
          OnTreePos = GetGadgetState(#Gad_NavTree)
          If OnTreePos < ListSize(Navtree())-1
            OnTreePos + 1
          Else
            OnTreePos = 0
          EndIf
          Set_NavTree_Position(OnTreePos)
        Case #Gad_RollInfo_History_List
          If ListSize(HistoryList()) > 0
            OnTreePos = GetGadgetState(#Gad_RollInfo_History_List)
            If OnTreePos < ListSize(HistoryList())-1 
              OnTreePos + 1
            Else
              OnTreePos = 0
            EndIf
            SetGadgetState(#Gad_RollInfo_History_List,OnTreePos)
            SelectElement(HistoryList(),OnTreePos)
            System\Selected_HistoryID = HistoryList()
            Image_Refresh_History(System\Selected_HistoryID)
          EndIf
      EndSelect
  
    Case #Menu_Popup13_Window_Restore
      ShowWindow_(WindowID(#Window_Main),#SW_MINIMIZE)
      Delay(250)
      ShowWindow_(WindowID(#Window_Main),#SW_RESTORE)
      System\WindowMinimized = 0
      RemoveSysTrayIcon(0)

    Case #Menu_ShortCut_Master_Import
      Debug "Import AMS Master"
      Import_AMS_Master()
    Case #Menu_File_Export_CSV
      If System\Showing_Panel = #Panel_Group_List
        Export_CSV(0)
      EndIf
      If System\Showing_Panel = #Panel_Roll_Info
        Export_CSV(1)
      EndIf
    Case #Menu_File_Export_XLS
      If System\Showing_Panel = #Panel_Group_List
        Export_Excel(0)
      EndIf
      If System\Showing_Panel = #Panel_Roll_Info
        Export_Excel(1)
      EndIf
    Case #Menu_File_Export_PDF
      If System\Showing_Panel = #Panel_Group_List
        Debug "Exporting Group to PDF"
        Export_RollReport_PDF()
      EndIf
      If System\Showing_Panel = #Panel_Roll_Info
        Debug "Exporting Rollinfo to PDF"
        Export_RollInfo_PDF()
      EndIf 
    Case #Menu_File_Export_Image_ClipBoard
      Image_FullScreen_Grab(1000)
      Export_Image(1)
    Case #Menu_File_Export_Image_File
      Image_FullScreen_Grab(1000)
      Export_Image(3)
    Case #Menu_File_Export_Image_Email
      Image_FullScreen_Grab(1000)
      Export_Image(2)
      
    Case #Menu_File_Quit
      Program_End()
    Case #Menu_Options_Settings
      Init_Settings()
    Case #Menu_Help_About
      Init_About(#Window_Main)
    Case #Menu_Help_ViewEULA
      Init_Eula(1)
    Case #Menu_Help_CheckForUpdates
      Tool_CheckForUpdate()
    Case #Menu_Help_Input_Code_Import
      Init_Code_Input(0)
    Case #Menu_Help_Input_Code_Export
      Init_Code_Input(1)
    Case #Menu_Options_Admin_Mode
      Init_Test()
    Case #Menu_Popup0_Edit_CompanyInfo
      Init_CS_Editor(0)
      
    Case #Menu_Popup0_Add_Site
      Database_Create_Site()
      
    Case #Menu_Popup0_Company_Rename ;/ change company name, store in variable & write entry to database.
      Result.S = InputRequesterEx(tTxt(#Str_Editcompanyname),tTxt(#Str_Pleaseinputnewname),System\Database_Company)
      If Result <> "" And Result <> System\Database_Company
        ;/ Write entry to database
        System\Database_Company = Result
        ;Debug "*** Setting Record Limit : "+Str(System\Settings_RollLimit)+" ***"
        Code.S = EncryptCode("ARK"+Chr(10)+System\Database_Company+Chr(10)+Str(System\Settings_SiteLimit)+Chr(10)+Str(System\Settings_RollLimit)+Chr(10)+Str(System\Settings_ReadingsLimit),"OpenWindow") ;/DNT
        Database_Update(#Databases_Master,"UPDATE AMS_Settings SET Code='"+Code.S+"';",#PB_Compiler_Line)
        Redraw_NavTree()
        Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
      EndIf

    Case #Menu_Popup1_Edit_SiteName ;/ change site name, store in variable & write entry to database.
      If Check_Manager_Mode()
        SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
        Code.s = NavTree()\String
        If Left(Code.s,1) = "*" : Code.s = Right(code.s,Len(code.s)-1) : EndIf
        Result.S = InputRequesterEx(tTxt(#Str_Editcompanyname),tTxt(#Str_Pleaseinputnewname),Code.s)
        If Result <> "" And Result <> Code.s
          ;/ Write entry to database
          Database_Update(#Databases_Master,"UPDATE AMS_Sites SET Name='"+Result.S+"' WHERE ID = "+Str(NavTree()\SiteID)+";",#PB_Compiler_Line)
          Database_SetSiteTimeStamp(Navtree()\SiteID)
          Redraw_NavTree()
          Show_Window(#Panel_Group_List,#PB_Compiler_Line)
        EndIf
      EndIf 
      
    Case #Menu_Popup1_Edit_SiteInfo
      If Check_Manager_Mode()
        SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
        Init_CS_Editor(Navtree()\SiteID)
      EndIf
    Case #Menu_Popup1_Show_SiteInfo
      SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
      Init_Site_Info(Navtree()\SiteID)
    Case #Menu_Popup1_Add_Group
      If Check_Manager_Mode()
        SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
        Debug "Adding Group to Site: "+Str(NavTree()\SiteID)
        Database_Create_Group(NavTree()\SiteID)
        Database_SetSiteTimeStamp(Navtree()\SiteID)
      EndIf
    Case #Menu_Popup1_SetasDefaultSite
      If Check_Manager_Mode()
        SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
        System\Default_Site = Navtree()\SiteId
        Debug "Settings site to default: "+Str(System\Default_Site)
        Database_SaveSettings()
;        Redraw_NavTree()
        System\Refresh_NavTree_Type = #NavTree_Site
        System\Refresh_NavTreeID = System\Default_Site       
      EndIf
      
    Case #Menu_Popup1_Delete_Site
      If Check_Manager_Mode()
        SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
        Database_Delete_Site(Navtree()\SiteID)
      EndIf
      
    Case #Menu_Popup2_Add_Roll
      SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
      Database_Create_Roll(NavTree()\GroupID)
      
    Case #Menu_Popup2_Group_Delete
      If Check_Manager_Mode()
        Debug "Deleting Group"
        Database_Delete_Group(NavTree()\GroupID)
      EndIf
      
    Case #Menu_Popup2_Group_Rename
      If Check_Manager_Mode()
        Debug "Renaming Group: "+Str(NavTree()\GroupID)
        Database_Rename_Group(NavTree()\GroupID)
      EndIf
      
    Case #Menu_Popup3_Roll_Rename
      If Check_Manager_Mode()
        Debug "Renaming Roll: "+Str(NavTree()\RollID)
        Database_Rename_Roll(NavTree()\RollID)
      EndIf
      
    Case #Menu_Popup3_Roll_Delete
      If Check_Manager_Mode()
        SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
        Database_Delete_Roll(NavTree()\RollID,NavTree()\String)
      EndIf
      
      
    Case #Menu_Popup3_Roll_Assign
      SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
      Init_Roll_GroupAssign(NavTree()\RollID,NavTree()\SiteID)
    Case #Menu_Popup3_Roll_Unassign
      SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
      Position = GetGadgetState(#Gad_NavTree)
      Group = Val(Database_StringQuery("Select ID FROM AMS_Groups where Type = '0' and SiteID = '"+Str(NavTree()\SiteID)+"';"))
      RollID = NavTree()\RollID
      Database_Reassign_Roll(NavTree()\RollID,Group.i)
      Debug NavTree()\SiteID
      Debug "Group ID: "+Str(Queryi)
      Redraw_NavTree()
      NavTree_SetToRollID(RollID)

    Case #Menu_Popup5_GeneralHistory_Delete
      SelectElement(DamageList(),GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))
      Resulti.i = MessageRequester(tTxt(#Str_Deletegeneralhistory)+"?",tTxt(#Str_Deleteselectedhistoryentry)+" - "+tTxt(#Str_Areyousure)+"?",#PB_MessageRequester_YesNo)
      If Resulti = #PB_MessageRequester_Yes
        Database_Update(#Databases_Master,"Delete From AMS_General_History Where ID = "+Str(DamageList()),#PB_Compiler_Line)
        Database_SetRollTimeStamp(System\Selected_Roll_ID)
        System\Showing_RollID = 999999
        Redraw_RollID(System\Selected_Roll_ID)
      EndIf
    Case #Menu_Popup5_GeneralHistory_Edit
      SelectElement(DamageList(),GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))
      Init_Window_GeneralHistory_Control(System\Selected_Roll_ID,DamageList())
    Case #Menu_Popup5_GeneralHistory_Insert
      Init_Window_GeneralHistory_Control(System\Selected_Roll_ID)
      
    Case #Menu_Popup6_Original_Reading_Delete
      If Check_Manager_Mode()
        ;/ Check if there are historical readings first, if so, don't allow delete.
        Resulti = Database_CountQuery("Select Count(*) From AMS_Roll_Data Where RollID = "+Str(System\Selected_Roll_ID)+";",#PB_Compiler_Line)
        If Resulti > 0
          MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Sorry)+", "+tTxt(#Str_youcannotdeletethemasterreadingiftherearehistoricalreadingspresent),#PB_MessageRequester_Ok)
        Else
          Resulti.i = MessageRequester(tTxt(#Str_Deleteoriginalreading)+"?",tTxt(#Str_Deleteoriginalreading)+" - "+tTxt(#Str_Areyousure)+"?",#PB_MessageRequester_YesNo)
          If Resulti = #PB_MessageRequester_Yes
            Database_Update(#Databases_Master,"Update AMS_Roll_Master Set ReadingDate = 0, Vol1 = 0,Vol2 = 0,Vol3 = 0,Vol4 = 0, Vol5 = 0, TopSnapImage = '' Where ID = "+Str(System\Selected_Roll_ID),#PB_Compiler_Line)
            Database_SetRollTimeStamp(System\Selected_Roll_ID)
            System\Showing_RollID = 999999
            Redraw_RollID(System\Selected_Roll_ID)
          EndIf
        EndIf 
      EndIf
      
    Case #Menu_Popup6_Original_Reading_Edit
      If Check_Manager_Mode()
        Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Overwrite,#Reading_Master)
      EndIf
        
    Case #Menu_Popup6_Original_Reading_Insert
      
      Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Insert,#Reading_Master)
      
    Case #Menu_Popup7_Historical_Reading_Delete
      If Check_Manager_Mode()
        Resulti.i = MessageRequester(tTxt(#Str_Deletehistoricalreading)+"?",tTxt(#Str_Deletehistoricalreading)+" - "+tTxt(#Str_Areyousure)+"?",#PB_MessageRequester_YesNo)
        If Resulti = #PB_MessageRequester_Yes
          Database_Update(#Databases_Master,"Delete From AMS_Roll_Data Where ID = "+Str(HistoryList()),#PB_Compiler_Line)
          Database_SetRollTimeStamp(System\Selected_Roll_ID)
          System\Showing_RollID = 999999
          Redraw_RollID(System\Selected_Roll_ID)
        EndIf
      EndIf
      
    Case #Menu_Popup7_Historical_Reading_Edit
      If Check_Manager_Mode()
        Debug "Original Roll Data - Editting!!"
        SelectElement(HistoryList(),GetGadgetState(#Gad_RollInfo_History_List))
        Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Overwrite,#Reading_Historical,HistoryList())
        ;      SelectElement(DamageList(),GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))
        ;      Init_Window_GeneralHistory(System\Selected_Roll_ID,DamageList())
      EndIf
    
    Case #Menu_Popup7_Historical_Reading_Insert

      Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Insert,#Reading_Historical)

      ;      Init_Window_GeneralHistory(System\Selected_Roll_ID)
    Case #Menu_Popup8_Manufacturer_Delete
    Case #Menu_Popup8_Manufacturer_Edit
    Case #Menu_Popup8_Manufacturer_Insert
      
      ;/ Original
    Case #Menu_Popup10_ImportImage ;/ Original, import image
      Image_Manual_Load(1)
    Case #Menu_Popup10_SaveImage ;/ Original, Save image
      Image_Manual_Save(1)
      
    Case #Menu_Popup10_ViewIn2d
      Show_Window(#Panel_2D_View,#PB_Compiler_Line)
      System\Image2d_RollID = System\Selected_Roll_ID
      Handle_2d_Analysis(0)
      
    Case #Menu_Popup10_ViewIn3d
      Show_Window(#Panel_3d_View,#PB_Compiler_Line)
      System\Image3d_RollID = System\Selected_Roll_ID
      
      ;/ Historical
    Case #Menu_Popup11_ImportImage 
      If System\Selected_HistoryID > -1
        Image_Manual_Load(0,System\Selected_HistoryID)
      Else
        MessageRequester(tTxt(#Str_Error)+"...",tTxt(#Str_Youcannotimportahistoricalimageunlesshistoricaldataexists),#PB_MessageRequester_Ok)
      EndIf
    
    Case #Menu_Popup11_ViewIn2d
      Show_Window(#Panel_2D_View,#PB_Compiler_Line)
      System\Image2d_RollID = System\Selected_Roll_ID
      Handle_2d_Analysis(1)
      
    Case #Menu_Popup11_ViewIn3d
      Show_Window(#Panel_3d_View,#PB_Compiler_Line)
      System\Image3d_RollID = System\Selected_Roll_ID
    ;/ Historical
      
    Case #Menu_Popup11_SaveImage ;/ Original, Save image
      Image_Manual_Save(2)
    Case #Menu_Popup14_ImageExport_ToClipBoard
      Export_Image(1)
    Case #Menu_Popup14_ImageExport_ToEmail
      Export_Image(2)
    Case #Menu_Popup14_ImageExport_ToFile
      Export_Image(3)

  EndSelect
EndProcedure
Procedure Process_Window_Events()
  Protected TempL.i, RollID.i, MyLoop.i
  If EventType() = #PB_EventType_Focus And GadgetType(EventGadget())=#PB_GadgetType_String
    SendMessage_(GadgetID(EventGadget()),#EM_SETSEL,0,-1)
  EndIf
  Select System\Window_Main_Events
    Case #Menu_Force_Refresh
      
    Case #PB_Event_SysTray
      If EventType() = #PB_EventType_LeftClick
        ShowWindow_(WindowID(#Window_Main),#SW_MINIMIZE)
        Delay(250)
        ShowWindow_(WindowID(#Window_Main),#SW_RESTORE)
        System\WindowMinimized = 0
        RemoveSysTrayIcon(0)
      EndIf
      
      If EventType() = #PB_EventType_RightClick 
        If IsIconic_(WindowID(#Window_Main))
          DisplayPopupMenu(13, WindowID(#Window_Main))
        EndIf 
      EndIf
    Case #PB_Event_GadgetDrop
      Debug "Drag-Move Ending..."
      If EventDropType() = #PB_Drop_Private And EventDropPrivate() = 0 And System\Drag_Selected > 0
        
        System\Drag_Target = GetGadgetState(#Gad_NavTree) 
        
        If System\Drag_Target > -1
          
          ;/ identify original RollID - Overwrite drag 
          SelectElement(NavTree(),System\Drag_Selected)
          System\Drag_Selected = NavTree()\RollID
          
          ;/ See if we've dragged over compatible Source.
          SelectElement(NavTree(),System\Drag_Target)
          If NavTree()\GroupID > 0 ;/ over a press, or a roll
            Debug "Reassigning"
            ;/ reallocating logic here
            
            Database_Reassign_Roll(System\Drag_Selected,NavTree()\GroupID)
            
          Else
            ;/ Do nothing, other than resetting flags
            Debug "Not Moving!"
            System\Drag_Target = -1 : System\Drag_Selected = -1
          EndIf
        EndIf
      Else
        Debug "Move Failed :("
        Debug "Does: "+Str(EventDropType())+" = "+Str(#PB_Drop_Private)+"?"
        Debug "Does: "+Str(EventDropPrivate())+" = 0 ?"
        Debug "Does: "+Str(System\Drag_Selected)+" have greater value than 0?"
      EndIf
      
    Case #PB_Event_SizeWindow
      SmartWindowRefresh(#Window_Main,0)
      SendMessage_(WindowID(0),#WM_SETREDRAW,#False,0)
      ResizeGadgets()
      ;Flush_Events()
      ;Form_Update_Images()
      SendMessage_(WindowID(0),#WM_SETREDRAW,#True,0)
      RedrawWindow_(WindowID(#Window_Main),#Null,#Null,#RDW_INVALIDATE|#RDW_UPDATENOW|#RDW_ERASE)
      SmartWindowRefresh(#Window_Main,1)
      
    Case #PB_Event_Menu 
      ;Message("Menu Item: "+Str(EventMenu()) +" selected")  ;/DNT
      Process_Menu_Events()
      
    Case #PB_Event_Gadget
      System\LastSelectedGadget = EventGadget()
      
      Select System\LastSelectedGadget
        Case #Gad_RollInfo_Import_New
          Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Insert,-1)
        Case #Gad_Icon_Manager_Mode

          If System\Manager_Mode = 1
            System\Manager_Mode = 0
            GadgetToolTip(#Gad_Icon_Manager_Mode,tTxt(#Str_ManagerMode)+":"+" "+tTxt(#Str_CurrentlyOff))
            SetGadgetAttribute(#Gad_Icon_Manager_Mode,#PB_Button_Image,ImageID(#Image_Padlock_Closed))
          Else
            If Init_Password_Requester() = 1
              System\Manager_Mode = 1
              Debug "Manager Mode on"
              GadgetToolTip(#Gad_Icon_Manager_Mode,tTxt(#Str_ManagerMode)+":"+" "+tTxt(#Str_CurrentlyOn))
              SetGadgetAttribute(#Gad_Icon_Manager_Mode,#PB_Button_Image,ImageID(#Image_Padlock_Open))
            Else
              Debug "Manager mode remains off"
              MessageRequester(tTxt(#Str_Sorry),tTxt(#Str_Incorrectpasscodeentered)+", "+tTxt(#Str_Pleasetryagain))
;              SetGadgetState(#Gad_Icon_Manager_Mode,0)
            EndIf
          EndIf

        Case #Gad_AutoImport
          System\LiveMonitor = GetGadgetState(#Gad_AutoImport)
          Database_SaveSettings()
          If System\LiveMonitor = 0
            GadgetToolTip(#Gad_AutoImport,tTxt(#Str_Toggleautomaticimporting)+":"+tTxt(#Str_Currentlyoff))
            ;WindowShowBalloonTip(#Window_Main,0,"AMS Message","Live Monitoring for AMS Exports is Off",3000)
          Else
            GadgetToolTip(#Gad_AutoImport,tTxt(#Str_Toggleautomaticimporting)+":"+tTxt(#Str_Currentlyon))
            ;WindowShowBalloonTip(#Window_Main,0,"AMS Message","Live Monitoring for AMS Exports is ON",3000)
          EndIf
        Case #Gad_Icon_Export_CSV
          If System\Showing_Panel = #Panel_Group_List : Export_CSV(0) : EndIf
          If System\Showing_Panel = #Panel_Roll_Info  : Export_CSV(1) : EndIf
        Case #Gad_Icon_Export_XLS
          If System\Showing_Panel = #Panel_Group_List : Export_Excel(0) : EndIf
          If System\Showing_Panel = #Panel_Roll_Info  : Export_Excel(1) : EndIf
        Case #Gad_Icon_Export_PDF
          If System\Showing_Panel = #Panel_Group_List : Export_RollReport_PDF() : EndIf
          If System\Showing_Panel = #Panel_Roll_Info  : Export_RollInfo_PDF() : EndIf
        Case #Gad_Icon_Export_Print
          If System\Showing_Panel = #Panel_Group_List : Export_RollReport_Print() : EndIf
          If System\Showing_Panel = #Panel_Roll_Info  : Export_RollInfo_Print() : EndIf
          
        Case #Gad_Icon_Export_IMG
           ;/ Grab the image before the menu is displayed as stops any delays waiting for the menu text to fade out
          Image_FullScreen_Grab(0)
          DisplayPopupMenu(14,WindowID(#Window_Main))
        Case #Gad_SQL_Run
            If GetGadgetState(#Gad_SQL_QueryUpdateCombo) = 0 ;/ query mode
              SQLite_Process_Live_Query()
            Else
              SQLite_Process_Live_Update()
            EndIf
          
        Case #Gad_SQL_Query_Txt
          If Multi_Site_Mode = 0
            If GetGadgetState(#Gad_SQL_QueryUpdateCombo) = 0 ;/ query mode
              SQLite_Process_Live_Query()
            EndIf
            
          Else
            If GetGadgetState(#Gad_SQL_QueryUpdateCombo) = 0 ;/ query mode
              SQLite_Process_Live_Query()
            EndIf
            
          EndIf
          
        Case #Gad_Report_Preset_Combo
          ;          Debug "Selected Filter: "+Str(GetGadgetState(#Gad_Report_Preset_Combo))
          Redraw_Report(System\Last_Drawn_Report_SiteId,System\Last_Drawn_Report_GroupId)
        Case #Gad_Report_Style_Combo
          Redraw_Report(System\Last_Drawn_Report_SiteId,System\Last_Drawn_Report_GroupId)
        Case #Gad_Report_SortDirection_Combo
          Redraw_Report(System\Last_Drawn_Report_SiteId,System\Last_Drawn_Report_GroupId)
        Case #Gad_Report_SortBy_Combo
          Redraw_Report(System\Last_Drawn_Report_SiteId,System\Last_Drawn_Report_GroupId)
        Case #Gad_Report_ReportList
          If EventType() = #PB_EventType_LeftDoubleClick
            TempL = GetGadgetState(#Gad_Report_ReportList)
            If TempL > -1
              SelectElement(ReportLine_RollID(),TempL)
              Debug "Selected RollID?: "+Str(ReportLine_RollID())
              RollID = ReportLine_RollID()
              If RollID > 0
              ;/ identify line on Navtree that it refers to:
              ForEach NavTree()
                If NavTree()\RollID = RollID
                  Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
                  SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
                  Redraw_RollID(RollID)
                  Break
                EndIf
              Next
              EndIf 
            EndIf
          EndIf
        Case #Gad_Report_New
          Init_Presets(1)
        Case #Gad_Report_Edit
          Init_Presets(2)
        Case #Gad_Report_Delete
          Init_Presets(3)
          
        Case #Gad_RollInfo_Commit; #Gad_RollInfo_Start To #Gad_RollInfo_Finish
          Database_Update_RollMaster_FromForm(System\Selected_Roll_ID)
          System\Showing_RollID = 0
          Redraw_RollID(System\Selected_Roll_ID)
          RollInfo_CheckEditted()
        Case #Gad_RollInfo_GeneralHistory_History_List
          If EventType() = #PB_EventType_RightClick
            DisplayPopupMenu(5,WindowID(#Window_Main))
          EndIf
          If EventType() = #PB_EventType_LeftDoubleClick
            If GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List) > -1
              If ListSize(DamageList()) > 0 And GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List) < ListSize(DamageList())
                SelectElement(DamageList(),GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))
                Init_Window_GeneralHistory_Control(System\Selected_Roll_ID,DamageList())
              EndIf
            EndIf
          EndIf
          
        Case #Gad_RollInfo_Hide_Begin To #Gad_RollInfo_Comment_Box
          RollInfo_CheckEditted()
        Case #Gad_RollInfo_Undo
          System\Refresh_Roll_Information = 1
        Case #Gad_SQL_Set
          SQL_Set_Example()
        Case #Gad_TroikaButton
          RunProgram(System\Weblink)  ;/DNT
        Case #Gad_SearchBox
          If GetGadgetTextMac(#Gad_SearchBox) <> "" ;And Len(GetGadgetTextMac(#Gad_SearchBox)) > 1
            ForEach NavTree()
              If FindString(UCase(NavTree()\String),UCase(GetGadgetTextMac(#Gad_SearchBox)),1) > 0
                SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
                If NavTree()\Type = #NavTree_Site
                  System\Last_Drawn_Report_SiteID = NavTree()\SiteID
                  System\Last_Drawn_Report_GroupID = -1
                  Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
                  Show_Window(#Panel_Group_List,#PB_Compiler_Line)
                EndIf
                
                If NavTree()\Type = #NavTree_Group
                  System\Last_Drawn_Report_SiteID = NavTree()\SiteID
                  System\Last_Drawn_Report_GroupID = NavTree()\GroupID
                  Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
                  Show_Window(#Panel_Group_List,#PB_Compiler_Line)
                EndIf
                
                If NavTree()\Type = #NavTree_Roll
                  Redraw_RollID(NavTree()\RollID)
                  Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
                EndIf
                Break
              EndIf 
            Next 
          EndIf 
        Case #Gad_SearchNext
          System\CurrentSearchPos = GetGadgetState(#Gad_NavTree)
          If GetGadgetTextMac(#Gad_SearchBox) <> "" ;And Len(GetGadgetTextMac(#Gad_SearchBox)) > 1
            ForEach NavTree()
              If FindString(UCase(NavTree()\String),UCase(GetGadgetTextMac(#Gad_SearchBox)),0) > 0 And ListIndex(NavTree()) > System\CurrentSearchPos
                SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
                If NavTree()\Type = #NavTree_Site
                  System\Last_Drawn_Report_SiteID = NavTree()\SiteID
                  System\Last_Drawn_Report_GroupID = -1
                  Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
                  Show_Window(#Panel_Group_List,#PB_Compiler_Line)
                EndIf
                
                If NavTree()\Type = #NavTree_Group
                  System\Last_Drawn_Report_SiteID = NavTree()\SiteID
                  System\Last_Drawn_Report_GroupID = NavTree()\GroupID
                  Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
                  Show_Window(#Panel_Group_List,#PB_Compiler_Line)
                EndIf
                
                If NavTree()\Type = #NavTree_Roll
                  Redraw_RollID(NavTree()\RollID)
                  Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
                EndIf
                Break
              EndIf 
            Next 
          EndIf 
        Case #Gad_SearchPrevious
          System\CurrentSearchPos = GetGadgetState(#Gad_NavTree)
          If GetGadgetTextMac(#Gad_SearchBox) <> ""
            For MyLoop = System\CurrentSearchPos-1 To 1 Step -1
              SelectElement(NavTree(),MyLoop)
              If FindString(UCase(NavTree()\String),UCase(GetGadgetTextMac(#Gad_SearchBox)),0) > 0 And ListIndex(NavTree()) < System\CurrentSearchPos
                SetGadgetState(#Gad_NavTree,ListIndex(NavTree()))
                If NavTree()\Type = #NavTree_Site
                  System\Last_Drawn_Report_SiteID = NavTree()\SiteID
                  System\Last_Drawn_Report_GroupID = -1
                  Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
                  Show_Window(#Panel_Group_List,#PB_Compiler_Line)
                EndIf
                
                If NavTree()\Type = #NavTree_Group
                  System\Last_Drawn_Report_SiteID = NavTree()\SiteID
                  System\Last_Drawn_Report_GroupID = NavTree()\GroupID
                  Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
                  Show_Window(#Panel_Group_List,#PB_Compiler_Line)
                EndIf
                
                If NavTree()\Type = #NavTree_Roll
                  Redraw_RollID(NavTree()\RollID)
                  Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
                EndIf
                Break
              EndIf 
            Next 
          EndIf 

        Case #Gad_RollInfo_Image_Reference
          If EventType()=#PB_EventType_RightClick
            DisplayPopupMenu(10,WindowID(#Window_Main))
          EndIf
          
        Case #Gad_RollInfo_Image_Latest
          If EventType()=#PB_EventType_RightClick
            DisplayPopupMenu(11,WindowID(#Window_Main))
          EndIf
          
        Case #Gad_RollInfo_GeneralHistory_History_List
          If EventType() = #PB_EventType_LeftDoubleClick
            If GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List) > -1
              SelectElement(DamageList(),GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))
              Init_Window_GeneralHistory_Control(System\Selected_Roll_ID,DamageList())
            EndIf
          EndIf
          
          If EventType()=#PB_EventType_RightClick
            DisableMenuItem(5,#Menu_Popup5_GeneralHistory_Delete,0)
            DisableMenuItem(5,#Menu_Popup5_GeneralHistory_Edit,0)
            If GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List) > -1
              SelectElement(DamageList(),GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))
              Debug "On line: "+Str(GetGadgetState(#Gad_RollInfo_GeneralHistory_History_List))+" - DamageID: "+Str(DamageList())
            Else
              DisableMenuItem(5,#Menu_Popup5_GeneralHistory_Delete,1)
              DisableMenuItem(5,#Menu_Popup5_GeneralHistory_Edit,1)
              Debug "Clicked Damage list whilst not over a line"
            EndIf 
            DisplayPopupMenu(5,WindowID(#Window_Main))
          EndIf

        Case #Gad_RollInfo_Original_List
          If EventType() = #PB_EventType_LeftDoubleClick
            If Check_Manager_Mode()
              Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Overwrite,#Reading_Master)
            EndIf
            
          EndIf
          If EventType()=#PB_EventType_RightClick
            DisableMenuItem(6,#Menu_Popup6_Original_Reading_Delete,0) ;/ enable all 3 items
            DisableMenuItem(6,#Menu_Popup6_Original_Reading_Edit,0)
            DisableMenuItem(6,#Menu_Popup6_Original_Reading_Insert,0)
            
            If GetGadgetItemText(#Gad_RollInfo_Original_List,0,0) = ""
              DisableMenuItem(6,#Menu_Popup6_Original_Reading_Delete,1) ;/ enable all 3 items
              DisableMenuItem(6,#Menu_Popup6_Original_Reading_Edit,1)
            Else
              DisableMenuItem(6,#Menu_Popup6_Original_Reading_Insert,1)
            EndIf 
            DisplayPopupMenu(6,WindowID(#Window_Main))
          EndIf
          
        Case #Gad_RollInfo_History_List

          If EventType() = #PB_EventType_LeftClick
            If GetGadgetState(#Gad_RollInfo_History_List) > -1
              SelectElement(HistoryList(),GetGadgetState(#Gad_RollInfo_History_List))
              System\Selected_HistoryID = HistoryList()
              Image_Refresh_History(System\Selected_HistoryID)
            EndIf
          EndIf            
          If EventType() = #PB_EventType_LeftDoubleClick
            If GetGadgetState(#Gad_RollInfo_History_List) > -1
              If Check_Manager_Mode()
                SelectElement(HistoryList(),GetGadgetState(#Gad_RollInfo_History_List))
                System\Selected_HistoryID = HistoryList()
                Image_Refresh_History(System\Selected_HistoryID)
                Init_Window_Readings_Edit(System\Selected_Roll_ID,#Database_Overwrite,#Reading_Historical,HistoryList())
              EndIf
              
            EndIf
          EndIf
          
          If EventType()=#PB_EventType_RightClick
            DisableMenuItem(7,#Menu_Popup7_Historical_Reading_Delete,0)
            DisableMenuItem(7,#Menu_Popup7_Historical_Reading_Edit,0)
            DisableMenuItem(7,#Menu_Popup7_Historical_Reading_Insert,0)
            
            If GetGadgetState(#Gad_RollInfo_History_List) > -1
              SelectElement(HistoryList(),GetGadgetState(#Gad_RollInfo_History_List))
              System\Selected_HistoryID = HistoryList()
              Debug "On line: "+Str(GetGadgetState(#Gad_RollInfo_History_List))+" - HistoryID: "+Str(HistoryList())
            Else
              DisableMenuItem(7,#Menu_Popup7_Historical_Reading_Delete,1)
              DisableMenuItem(7,#Menu_Popup7_Historical_Reading_Edit,1)
              Debug "Clicked History list whilst not over a line"
            EndIf 
            DisplayPopupMenu(7,WindowID(#Window_Main))
          EndIf
          
        Case #Gad_Report_ExportCSV
          Export_CSV(0)
        Case #Gad_Report_ExportXLS
          Export_Excel(0)
        Case #Gad_RollInfo_Import_AMS
          Import_AMS()
        Case #Gad_Report_ExportPDF
          Export_RollReport_PDF()
          
        Case #Gad_2D_Analysis_Image
          Debug "2d Event: "+Str(EventType())
          
        Case #Gad_NavTree
          
          If EventType() = #PB_EventType_DragStart
            Debug "Drag-Move Initialised"
            System\Drag_Selected = GetGadgetState(#Gad_NavTree)
            If System\Drag_Selected > -1 ;/ actually dragged something
              Debug "Drag Flag set"
              SelectElement(NavTree(),System\Drag_Selected)
              If Navtree()\RollID > 0 ;/ have dragged a roll, good!
                DragPrivate(0, #PB_Drag_Move)
              Else
                Debug "Drag Cancelled"
                System\Drag_Selected = 0
              EndIf
            EndIf
          EndIf
          
          If EventType()=#PB_EventType_RightClick
            SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
            Debug "GadLine: "+Str(GetGadgetState(#Gad_NavTree))+" - Level: "+Str(NavTree()\Type)
            If NavTree()\Type = #NavTree_Company : DisplayPopupMenu(0,WindowID(#Window_Main)) : EndIf
            If NavTree()\Type = #NavTree_Site : DisplayPopupMenu(1,WindowID(#Window_Main)) : EndIf
            If NavTree()\Type = #NavTree_Group : DisplayPopupMenu(2,WindowID(#Window_Main)) : EndIf
            If NavTree()\Type = #NavTree_Roll : DisplayPopupMenu(3,WindowID(#Window_Main)) : EndIf
          EndIf
          
          If EventType()=#PB_EventType_LeftClick 
            If GetGadgetState(#Gad_NavTree) < 0 : SetGadgetState(#Gad_NavTree,0) : EndIf
            
;             Select NavTree()\Type
;               Case #NavTree_Company
;                 Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
;               Case #NavTree_Site
;                 Show_Window(#Panel_Group_List,#PB_Compiler_Line)
;               Case #NavTree_Group
;                 Show_Window(#Panel_Group_List,#PB_Compiler_Line)
;               Case #NavTree_Roll
;                 Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
;             EndSelect
            
            SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
            Debug "Pos: "+Str(GetGadgetState(#Gad_NavTree))+" - Site: "+Str(Navtree()\SiteID)+" - Group: "+Str(Navtree()\GroupID)+" - Roll: "+Str(Navtree()\RollID)
            System\Selected_Site = Navtree()\SiteID
            System\Selected_Group = Navtree()\GroupID
            System\Selected_Roll_ID = Navtree()\RollID
            ;Debug "NavTree Clicked : "+Str(GetGadgetState(#Gad_NavTree))
            System\TV_Line = GetGadgetState(#Gad_NavTree)
            If System\TV_Line = -1 : System\TV_Line = 0 : EndIf 
            System\TV_Depth = GetGadgetItemAttribute(#Gad_NavTree,System\TV_Line,#PB_Tree_SubLevel)
            
            SelectElement(NavTree(),System\TV_Line)
            
            If NavTree()\Type = #NavTree_Company
              Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
              Redraw_HomeScreen()
            EndIf
            
            If NavTree()\Type = #NavTree_Site
              Show_Window(#Panel_Group_List,#PB_Compiler_Line)
              System\Last_Drawn_Report_SiteID = NavTree()\SiteID
              System\Last_Drawn_Report_GroupID = -1
              Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
            EndIf
            
            If NavTree()\Type = #NavTree_Group
              Show_Window(#Panel_Group_List,#PB_Compiler_Line)
              System\Last_Drawn_Report_SiteID = NavTree()\SiteID
              System\Last_Drawn_Report_GroupID = NavTree()\GroupID
              Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
            EndIf
            
            If NavTree()\Type = #NavTree_Roll
              Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
              Redraw_RollID(NavTree()\RollID)
            EndIf
            
            System\Selected_Roll_ID_Text = NavTree()\String
            System\Selected_Roll_ID = NavTree()\RollID
            
            ;Message("Event: "+Str(System\Window_Main_Events)+" - Type: "+Str(EventType())+" - TreegadgetState: "+Str(System\TV_Line)+" - "+Str(System\TV_Depth)) ;/DNT
            
          EndIf 
          
      EndSelect
      
  EndSelect
EndProcedure

;/ initiate the database environment
If UseSQLiteDatabase() = 0
  MessageRequester("Error","Unable to initialise the database environment, Exitting",#PB_MessageRequester_Ok)
  End
EndIf

Procedure Database_CreateLocalSettingsDB()
  Protected SQL.s, Result.i
    Debug "Creating local settings DB"
    
    ;/ create the new file
    If CreateFile(1,LocalSettingsDB) = 0
      ;/ If returned value is null, warn user and exit
      MessageRequester(tTxt(#Str_Error),tTxt(#Str_Systemsettingsfailure)+Chr(10)+Chr(10)+LocalSettingsDB)
      End
    EndIf
    
    CloseFile(1) 
    
    ;/ generate a database file
    OpenDatabase(#Databases_LocalSettings,LocalSettingsDB,"","",#PB_Database_SQLite) ;/ open database file
    
    ;/ create database table
    SQL = "Create Table [AMS_LocalSettings] ([Version] INT,  [Language] Int,  [ScreenUnit] Int,  [LengthUnit] Int,  [VolumeUnit] Int,  [DateFormat] Int,"
    SQL + "[VarianceGood] Int, [VarianceBad] Int,  [CapacityGood] Int, [CapacityBad] Int, [Monitor] Int, [ImportPath] Char, [Import_Delete] Int, "
    SQL + "[Database_Path] Char, [Default_Site] Int, [Polling_Interval] Int, [DefaultOnly] Int, [Show_Depth] Int);"
    
    Result = Database_Update(#Databases_LocalSettings,SQL,#PB_Compiler_Line)
    
    If Result = 0
      MessageRequester("Error","Unable to generate local settings database, exitting")  
      End
    EndIf
    
    ;/ Insert default values into table
    SQL = "INSERT INTO AMS_LocalSettings (Version, Language, ScreenUnit, LengthUnit, VolumeUnit, DateFormat, VarianceGood, VarianceBad, "
    SQL + "CapacityGood, CapacityBad, Monitor, ImportPath, Import_Delete, Database_Path, Default_Site, Polling_Interval, DefaultOnly) "
    SQL + "VALUES ('6', 'English', '0', '0', '0', '0', 5, 15, 95, 75, 0, 'C:\ExportAMS\', 1, '"+GetPathPart(DatabaseFile)+"', 1, 5, 0)"
    
    System\Database_Path = GetPathPart(DatabaseFile)
    
    Database_Update(#Databases_LocalSettings,SQL,#PB_Compiler_Line)
    
    CloseDatabase(#Databases_LocalSettings)

EndProcedure

;/ if in multi-site mode, need to load the local settings database file in order to retrieve the multi-site database location...
;If Multi_Site_Mode = 1
;/ If local database doesn't exist, create a default one
If FileSize(LocalSettingsDB) < 1 ;/ have to create db
  Database_CreateLocalSettingsDB()
EndIf
Debug "Local settings database location & name: "+LocalSettingsDB
If OpenDatabase(#Databases_LocalSettings,LocalSettingsDB,"","",#PB_Database_SQLite)
  System\Database_Path = Database_StringQuery("Select Database_Path from AMS_Localsettings;",#Databases_LocalSettings)
  DatabaseFile = System\Database_Path+"\AMS_SS.db" 
  ;CloseDatabase(#Databases_LocalSettings)
Else
  MessageRequester("Error","Unable to open the AMS settings database, Exitting"+Chr(10)+Chr(10)+"("+LocalSettingsDB+")",#PB_MessageRequester_Ok)
  End
EndIf
;EndIf

;/ Now loading main database file
System\DatabaseHandle = OpenDatabase(#Databases_Master,DatabaseFile,"","",#PB_Database_SQLite) 
If System\DatabaseHandle = 0
  ;  If Multi_Site_Mode = 1
  MS_CheckDatabaseLocation()
  DatabaseFile = System\Database_Path+"\AMS_SS.db"
  System\DatabaseHandle = OpenDatabase(#Databases_Master,DatabaseFile,"","",#PB_Database_SQLite) 
  If System\DatabaseHandle = 0
    MessageRequester(tTxt(#Str_Error),tTxt(#Str_Unabletoopenfile)+":"+Chr(10)+DatabaseFile)
    End
  EndIf
  ;EndIf
  If FileSize(DatabaseFile) = -1
    MessageRequester("Error","Unable to open the database file:"+Chr(10)+DatabaseFile)
    End
  EndIf
EndIf

;/ Database opened okay at this point - Now check ability to write to the opened database:
If Database_WriteCheck() = 0
  MessageRequester("Error","Unable to write to the opened database:"+Chr(10)+DatabaseFile+Chr(10)+Chr(10)+"Please check if the database file is being locked by another program, or if your system level privilege is preventing access.")
  End
EndIf

If Multi_Site_Mode = 0 : Database_CheckVersion() : EndIf 
Database_LoadSettings()
Language_Parse_Files()
Language_Set(System\Settings_Language)
Refresh_Suitability_List()
Refresh_Manufacturer_List()
Database_CheckVersion() ;/ checks current database version & updates if required
PDF_Init()
SQL_Load_Examples()
Refresh_Group_List(1)
Init_Begin()
Init_Window_Main()
Init_End()
Redraw_NavTree()
Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)

;{- Main loop
Repeat
  System\Window_Main_Events = WaitWindowEvent(500) 
  
  If System\Window_Main_Events <> 0
    Process_Window_Events()
  EndIf
  
  If System\LiveMonitor = 1 And ElapsedMilliseconds() > System\LiveMonitorNextTime
    System\LiveMonitorNextTime = ElapsedMilliseconds()+1000 ;/ wait a second before repeating
    ;Debug "Calling Import Monitor"
    Import_Monitor()
  EndIf
  
  If GetAsyncKeyState_(#VK_F11)
    Repeat : Until GetAsyncKeyState_(#VK_F11) = 0
    Init_FullScreen()
  EndIf
  
  If System\Language_Update = 1
    CloseWindow(#Window_Main)
    Init_Window_Main()
    System\Language_Update = 0
    System\Refresh_NavTreeID = 1
    System\Showing_Panel = 1150
    Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
  EndIf
  
  If System\Refresh_NavTreeID > -1
    Debug "Refreshing NavTree"
    Redraw_NavTree()
    If System\Refresh_NavTree_Type = #NavTree_Group
      NavTree_SetToGroupID(System\Refresh_NavTreeID)
    EndIf 
    If System\Refresh_NavTree_Type = #NavTree_Roll
      NavTree_SetToRollID(System\Refresh_NavTreeID)
    EndIf 
    If System\Refresh_NavTree_Type = #NavTree_Site
      NavTree_SetToSiteID(System\Refresh_NavTreeID)
    EndIf 
    If GetGadgetState(#Gad_NavTree) < 0 : SetGadgetState(#Gad_NavTree,0) : EndIf
    SelectElement(Navtree(),GetGadgetState(#Gad_NavTree))

    If NavTree()\Type = #NavTree_Company
      Redraw_HomeScreen()
      Show_Window(#Panel_HomeScreen,#PB_Compiler_Line)
    EndIf
    
    If NavTree()\Type = #NavTree_Site
      System\Last_Drawn_Report_SiteID = NavTree()\SiteID
      System\Last_Drawn_Report_GroupID = -1
      Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
      Show_Window(#Panel_Group_List,#PB_Compiler_Line)
    EndIf
    
    If NavTree()\Type = #NavTree_Group
      System\Last_Drawn_Report_SiteID = NavTree()\SiteID
      System\Last_Drawn_Report_GroupID = NavTree()\GroupID
      Redraw_Report(System\Last_Drawn_Report_SiteID,System\Last_Drawn_Report_GroupID)
      Show_Window(#Panel_Group_List,#PB_Compiler_Line)
    EndIf
    
    If NavTree()\Type = #NavTree_Roll
      Redraw_RollID(NavTree()\RollID)
      Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
    EndIf
    
    System\Selected_Roll_ID_Text = NavTree()\String
    System\Selected_Roll_ID = NavTree()\RollID
    System\Selected_Group = NavTree()\GroupID
    System\Selected_Site = NavTree()\SiteID

    System\Refresh_NavTreeID = -1
    Flush_Events()
  EndIf 
  
  If System\Refresh_Roll_Information > 0
    If GetGadgetState(#Gad_NavTree) < 0 : SetGadgetState(#Gad_NavTree,0) : EndIf 
    SelectElement(NavTree(),GetGadgetState(#Gad_NavTree))
    If NavTree()\RollID > 0
      Redraw_RollID(NavTree()\RollID)
      System\Showing_Panel = 9999 : Show_Window(#Panel_Roll_Info,#PB_Compiler_Line)
      Debug "Showing Roll Info for RollID: "+Str(NavTree()\RollID)
      System\Refresh_Roll_Information = 0
      If System\Showing_Panel = #Panel_Roll_Info
        RollInfo_CheckEditted()
      EndIf
    EndIf
  EndIf 
  
  If Multi_Site_Mode = 1 ; poll check for multi site updates, live screen updating
    If ElapsedMilliseconds() > System\Next_Poll_Check
      System\Next_Poll_Check = ElapsedMilliseconds() + (System\PollingInterval * 1000)
      MS_Check_Screen_Updates()
    EndIf
  EndIf
  
  If System\Showing_Panel = #Panel_2D_View
    Handle_2d_Analysis(-1)
  EndIf

Until System\Window_Main_Events = #PB_Event_CloseWindow Or System\Quit = 1

End
;}

;{- Datasection
DataSection
  Chart:
  IncludeBinary "Images\1.ICO" ;/DNT
  Star:
  IncludeBinary "Images\2.ICO" ;/DNT
  Play:
  IncludeBinary "Images\3.ICO" ;/DNT
  Home:
  IncludeBinary "Images\4.ICO" ;/DNT
  SmallRoll:
  IncludeBinary "Images\Roll.bmp" ;/DNT
  SmallRoll_End:

  Factory:
  IncludeBinary "Images\factory.png" ;/DNT
  Factory_End:
  
  Factory2:
  IncludeBinary "Images\factory small.png" ;/DNT
  Factory2_End:
  
  Logo:
  IncludeBinary "Images\Troika Logo.png" ;/DNT
  Logo_End:

  Roll:
  IncludeBinary "Images\UnifiedRoll2.png" ;/DNT
  Roll_End:
  
  Roll_Opaque:
  IncludeBinary "Images\UnifiedRoll2_Opaque.png" ;/DNT
  Roll_Opaque_End:

  Roll_Pins:
  IncludeBinary "Images\UnifiedRollPins.png" ;/DNT
  Roll_PinsEnd:
  
  Roll_Pins_Opaque:
  IncludeBinary "Images\UnifiedRollPins_Opaque.png" ;/DNT
  Roll_Pins_Opaque_End:
  
  Logo_Opaque:
  IncludeBinary "Images\Troika Logo Opaque.png" ;/DNT
  Logo_Opaque_End:
  
  Roll_Opening:
  IncludeBinary "Images\opening.png" ;/DNT
  Roll_Opening_End:
  
  Roll_Opening_Opaque:
  IncludeBinary "Images\opening_Opaque.png" ;/DNT
  Roll_Opening_Opaque_End:
  
  Roll_Screen:
  IncludeBinary "Images\screen.png" ;/DNT
  Roll_Screen_End:
  
  Roll_Screen_Opaque:
  IncludeBinary "Images\screen_Opaque.png" ;/DNT
  Roll_Screen_Opaque_End:
  
  NoImageLoaded:
  IncludeBinary "Images\NoImageLoaded3.png" ;/DNT
  NoImageLoaded_End:
  
  Roll_Wall:
  IncludeBinary "Images\wallwidth.png" ;/DNT
  Roll_Wall_End:
  
  Roll_Wall_Opaque:
  IncludeBinary "Images\wallwidth_Opaque.png" ;/DNT
  Roll_Wall_Opaque_End:

  Group2:
  IncludeBinary "Images\group.bmp" ;/DNT
  Group2_End:

  AniCAM:
  IncludeBinary "Images\AniCAM.png" ;/DNT
  AniCAM_End:
  
  AniCAM_Opaque:
  IncludeBinary "Images\AniCAM_Opaque.png" ;/DNT
  AniCAM_Opaque_End:
  
  Splash:
  IncludeBinary "Images\Splash 4.png" ;/DNT
  Splash_End:
  
  AniCAMIcon:
  IncludeBinary "Images\AniCAM_Mini_T.ico" ;/DNT
  AniCAMIcon_End:
  
  Icon_IMG:
  IncludeBinary "Images\IMG1.png" ;/DNT
  Icon_IMG_END:
  
  Icon_XLS:
  IncludeBinary "Images\XLS3.png" ;/DNT
  Icon_XLS_END:
  
  Icon_CSV:
  IncludeBinary "Images\CSV3.png" ;/DNT
  Icon_CSV_END:
  
  Icon_PDF:
  IncludeBinary "Images\PDF3.png" ;/DNT
  Icon_PDF_END:
  
  Icon_AutoImport:
  IncludeBinary "Images\AutoImport4.png" ;/DNT
  Icon_AutoImport_End:
  
  BorderRolls:
  IncludeBinary "Images\BorderRolls3.png" ;/DNT
  BorderRolls_End:
  
  TroikaAMS:
  IncludeBinary "Images\Troika AMS2.png" ;/DNT
  TroikaAMS_End:
  
  Padlock_Open:
  IncludeBinary "Images\Padlock_Open.png" ;/DNT
  Padlock_Open_End:
  
  Padlock_Closed:
  IncludeBinary "Images\Padlock_Closed.png" ;/DNT
  Padlock_Closed_End:
  
  Print_Start:
  IncludeBinary "Images\Print.png" ;/DNT
  Print_End:
  
  
EndDataSection
;}

; IDE Options = PureBasic 5.30 (Windows - x86)
; CursorPosition = 770
; FirstLine = 102
; Folding = QBAEACCAAAAgA5CACYHAsAAEUAAgw+----
; EnableUnicode
; EnableXP
; EnableUser
; UseIcon = Images\AniCAM_Mini_T.ico
; Executable = Executable\Anilox Management System v1.25 Move database - User Mode.exe
; DisableDebugger
; Debugger = IDE
; EnablePurifier
; Watchlist = System\Settings_Volume_UnitMask