pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Stack {

    struct task{
        string title;
        uint32 timestamp;
        bool done;
    }

    mapping(uint8 => task) tasks_array;

    uint8 public num = 0;

	constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	// Modifier that allows to accept some external messages
	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}
/*
v добавить задачу (должен в сопоставление заполняться последовательный целочисленный ключ)
-v получить количество открытых задач (возвращает число)
-v получить список задач
v получить описание задачи по ключу
- удалить задачу по ключу
- отметить задачу как выполненную по ключу
*/

	// Function add 
	function add(string title) public checkOwnerAndAccept returns(uint8) {
        require(title != "", 103);
        num++;
        //mapping(uint8 => task) tasks_array;
		tasks_array[num] = task(title, now, false);
        return num;
	}

   	// Function count Open Tasks
 	function countOpenTasks() public checkOwnerAndAccept returns (uint8){
        require(num>0, 104);
        uint8 count = 0;

        for (uint8 i = 1; i<=num; i++){
            if(tasks_array[uint8(i)].done){
                count++;
            }
        }
        return count;
    }

   	// Function get List
	function getList() public checkOwnerAndAccept returns (string){
        require(num>0, 105);
              
        string list="";

        uint8 count = 0;

        for (uint8 i = 1; i<=num; i++){
            if(tasks_array[uint8(i)].title > ""){
                list += tasks_array[uint8(i)].title;
                if (tasks_array[i].done){
                    list += " - done; \n ";
                }else{
                    list += " - not completed; \n ";
                }                
            }
        }
        return list;
    }
    	

   	// Function get Task
	function getTask(uint8 i) public checkOwnerAndAccept returns (string){
        require(i>0, 106);
        string status="";
        if (tasks_array[i].done){
            status = " - done";
        }else{
            status = " - not completed";
        }

        return tasks_array[i].title + status;
	}

    // Function delete Task
	function deleteTask(uint8 i) public checkOwnerAndAccept returns (string){
        string tit;
        tit = tasks_array[i].title;

        delete tasks_array[i];

        return tit + " - deleted";
	}

    // Function done Task
	function doneTask(uint8 i) public checkOwnerAndAccept returns (string){
        string tit;
        tit = tasks_array[i].title;

        tasks_array[i].done = true;

        return tit + " - complited";
	}

}