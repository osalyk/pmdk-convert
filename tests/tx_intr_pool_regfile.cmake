# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2018-2020, Intel Corporation

include(${SRC_DIR}/helpers.cmake)

# prepare single file pools for testing for each version of PMDK
function(prepare_files version)
	execute(0 ${TEST_DIR}/create_${version}
		${DIR}/pool${version}a 16)

	execute(0 ${TEST_DIR}/create_${version}
		${DIR}/pool${version}c 32)
endfunction()

function(test_tx test_intr_tx)
	setup()

	list(LENGTH VERSION num)
	math(EXPR num "${num} - 1")

	set(index 1)

	while(index LESS num)
		list(GET VERSION ${index} curr_version)
		math(EXPR next "${index} + 1")
		list(GET VERSION ${next} next_version)

		if(next_version EQUAL "1.2")
			set(mutex "-X;1.2-pmemmutex")
		else()
			unset(mutex)
		endif()

		test_intr_tx(prepare_files ${curr_version} ${next_version})

		MATH(EXPR index "${index} + 1")
	endwhile()
endfunction()

test_tx(test_intr_tx)

cleanup()
