OrphanRecords
===============
This program is based on the Annotate Models plugin written by Dave Thomas and VisualizeModels plugin by Nils Franzen.
<br/>For more information about Annotate Models, see http://blogs.pragprog.com/cgi-bin/pragdave.cgi/Tech/Ruby/AnnotateModels.rdoc
<br/>For more information about Visualize Models, see http://visualizemodels.rubyforge.org/

Authors:
> Abhilash M A
<br/> Nils Franzen (Visualize Models)
<br/> Dave Thomas (Annotate Models)

Released under the same license as Ruby. No Support. No Warranty.

### orphan_records
Gem which show/delete the orphan records in your Rails applivcation

### Installation

    gem install orphan_records

### Usage

    rake orphan_records:show  # this rake task will show the list of orphan records

    rake orphan_records:delete  # this rake task will delete the orphan records
