/*
 * MATLAB Compiler: 4.8 (R2008a)
 * Date: Fri Mar 16 16:19:40 2012
 * Arguments: "-B" "macro_default" "-o" "ivireonn" "-W" "main" "-d"
 * "/home/seguritan/segall-lab/src" "-T"
 * "link:exe" "-v" "-N"
 * "/home/seguritan/segall-lab/nets/ann_vote.m" "-a"
 * "/home/seguritan/segall-lab/nets/AA_ONLY_96.15_129" "-a"
 * "/home/seguritan/segall-lab/nets/AA_ONLY_94.94_39" "-a"
 * "/home/seguritan/segall-lab/nets/AA_ONLY_93.67_67" "-a"
 * "/home/seguritan/segall-lab/nets/AA_ONLY_93.67_38" "-a"
 * "/home/seguritan/segall-lab/nets/AA_ONLY_93.67_37" 
 */

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_ivireonn_session_key[] = {
    '6', '3', '7', 'C', '1', '2', '5', '5', '0', 'C', '8', '4', '3', '6', '2',
    '5', '6', 'F', '8', 'F', 'F', 'F', '7', 'A', '9', '1', '6', '6', '6', '6',
    '7', '0', '5', '1', '0', '1', '8', '9', '7', '4', '1', 'C', 'E', 'E', 'F',
    '1', 'A', '4', 'E', 'E', '9', '5', 'C', 'C', '2', 'E', '2', '3', '7', 'F',
    '3', '5', '7', '1', '3', '1', '3', 'D', '8', '1', 'C', 'D', '1', '4', '4',
    '2', '2', 'D', 'F', 'F', '1', 'E', 'D', '0', '9', '3', 'B', '6', 'E', 'B',
    '3', '9', '4', '9', '3', 'D', 'C', 'D', '1', 'D', 'C', '2', '3', '5', '0',
    '3', '8', 'F', '7', '9', 'A', '7', 'B', '3', 'E', '8', 'B', 'F', '5', 'E',
    '2', '1', 'F', 'C', '7', '1', 'C', 'F', 'A', 'E', '1', '8', 'A', '3', '3',
    '0', '3', '6', '3', '6', '1', '4', '8', '0', '2', 'F', '0', '1', '4', '9',
    '1', '2', '3', 'A', 'A', '1', 'B', '7', 'F', 'E', '7', 'D', 'D', '7', 'D',
    '1', '3', '3', 'A', 'D', 'C', '9', 'A', 'C', '0', 'E', '2', '3', '0', '3',
    '2', '0', '0', 'A', 'E', '3', '5', '9', '3', '5', '7', '8', '1', '4', '6',
    'A', '7', '4', 'B', '2', '7', 'A', '7', 'E', '4', '3', 'C', '8', '0', 'B',
    '9', '4', 'F', '6', '5', '4', 'E', 'D', '5', '7', '2', '6', '2', '6', '3',
    '1', 'E', '8', 'E', '8', '6', 'D', '1', 'C', '9', 'E', 'E', '8', 'B', '8',
    'A', '8', 'B', '0', '4', '7', '6', 'E', '1', '3', '0', '2', '7', '3', '4',
    'E', '\0'};

const unsigned char __MCC_ivireonn_public_key[] = {
    '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9', '2',
    'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1', '0', '1',
    '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B', '0', '0', '3',
    '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1', '0', '0', 'C', '4',
    '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3', 'A', '5', '2', '0', '6',
    '5', '8', 'F', '6', 'F', '8', 'E', '0', '1', '3', '8', 'C', '4', '3', '1',
    '5', 'B', '4', '3', '1', '5', '2', '7', '7', 'E', 'D', '3', 'F', '7', 'D',
    'A', 'E', '5', '3', '0', '9', '9', 'D', 'B', '0', '8', 'E', 'E', '5', '8',
    '9', 'F', '8', '0', '4', 'D', '4', 'B', '9', '8', '1', '3', '2', '6', 'A',
    '5', '2', 'C', 'C', 'E', '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4',
    'D', '0', '8', '5', 'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2',
    'E', 'D', 'E', '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6',
    '3', '7', '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E',
    '6', '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
    '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1', 'B',
    'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9', '9', '0',
    '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0', 'B', '6', '1',
    'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B', '5', '8', 'F', 'C',
    '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6', 'E', 'B', '7', 'E', 'C',
    'D', '3', '1', '7', '8', 'B', '5', '6', 'A', 'B', '0', 'F', 'A', '0', '6',
    'D', 'D', '6', '4', '9', '6', '7', 'C', 'B', '1', '4', '9', 'E', '5', '0',
    '2', '0', '1', '1', '1', '\0'};

static const char * MCC_ivireonn_matlabpath_data[] = 
  { "ivireonn/", "toolbox/compiler/deploy/",
    "Users/vs/Documents/tftb/tftb-0.1/mfiles/", "$TOOLBOXMATLABDIR/general/",
    "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
    "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/elfun/",
    "$TOOLBOXMATLABDIR/specfun/", "$TOOLBOXMATLABDIR/matfun/",
    "$TOOLBOXMATLABDIR/datafun/", "$TOOLBOXMATLABDIR/polyfun/",
    "$TOOLBOXMATLABDIR/funfun/", "$TOOLBOXMATLABDIR/sparfun/",
    "$TOOLBOXMATLABDIR/scribe/", "$TOOLBOXMATLABDIR/graph2d/",
    "$TOOLBOXMATLABDIR/graph3d/", "$TOOLBOXMATLABDIR/specgraph/",
    "$TOOLBOXMATLABDIR/graphics/", "$TOOLBOXMATLABDIR/uitools/",
    "$TOOLBOXMATLABDIR/strfun/", "$TOOLBOXMATLABDIR/imagesci/",
    "$TOOLBOXMATLABDIR/iofun/", "$TOOLBOXMATLABDIR/audiovideo/",
    "$TOOLBOXMATLABDIR/timefun/", "$TOOLBOXMATLABDIR/datatypes/",
    "$TOOLBOXMATLABDIR/verctrl/", "$TOOLBOXMATLABDIR/codetools/",
    "$TOOLBOXMATLABDIR/helptools/", "$TOOLBOXMATLABDIR/demos/",
    "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/hds/",
    "$TOOLBOXMATLABDIR/guide/", "$TOOLBOXMATLABDIR/plottools/",
    "toolbox/local/", "$TOOLBOXMATLABDIR/datamanager/", "toolbox/compiler/" };

static const char * MCC_ivireonn_classpath_data[] = 
  { "" };

static const char * MCC_ivireonn_libpath_data[] = 
  { "" };

static const char * MCC_ivireonn_app_opts_data[] = 
  { "" };

static const char * MCC_ivireonn_run_opts_data[] = 
  { "" };

static const char * MCC_ivireonn_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_ivireonn_component_data = { 

  /* Public key data */
  __MCC_ivireonn_public_key,

  /* Component name */
  "ivireonn",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_ivireonn_session_key,

  /* Component's MATLAB Path */
  MCC_ivireonn_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  37,

  /* Component's Java class path */
  MCC_ivireonn_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_ivireonn_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_ivireonn_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_ivireonn_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "ivireonn_43849EEF608F49EEDF24E925B40D3668",

  /* MCR warning status data */
  MCC_ivireonn_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


