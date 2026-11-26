extends BoltTest
## Prova o fallback do runner: um teste deixa um override intencionalmente e o próximo
## método confirma que o runner removeu o fixture e restaurou o autoload.


const TEST_SAVE_PATH: String = "user://bolt_runner_isolation_test.json"


func test_a_runner_fixture_is_created() -> bool:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	check(SaveSystem.save_payload({"runner_fixture": true}), "grava fixture no caminho temporário")
	check(FileAccess.file_exists(TEST_SAVE_PATH), "fixture existe antes do teardown do runner")
	return true


func test_b_runner_teardown_resets_override_and_removes_fixture() -> bool:
	check_eq(SaveSystem.storage_path_override, "", "runner restaura override vazio entre métodos")
	check(not FileAccess.file_exists(TEST_SAVE_PATH), "runner remove somente o fixture temporário")
	return true
