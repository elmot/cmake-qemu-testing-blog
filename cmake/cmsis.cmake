if(NOT EXISTS ${CMAKE_SOURCE_DIR}/CMSIS/ARM.CMSIS.pdsc)
    message(STATUS "Download CMSIS ...")
    file(DOWNLOAD "https://github.com/ARM-software/CMSIS_5/releases/download/5.9.0/ARM.CMSIS.5.9.0.pack" cmsis.zip TIMEOUT 300)
    message(STATUS "Extract CMSIS ...")
    file(ARCHIVE_EXTRACT
            INPUT cmsis.zip
            DESTINATION "${CMAKE_SOURCE_DIR}/CMSIS")
    file(REMOVE ${PROJECT_BINARY_DIR}/cmsis.zip)
endif()
